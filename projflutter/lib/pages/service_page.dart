import 'package:flutter/material.dart';
import 'package:projflutter/data/app_data.dart';
import 'package:intl/intl.dart';

class ServicePage extends StatefulWidget {
  const ServicePage({super.key});

  @override
  State<ServicePage> createState() => _ServicePageState();
}

class _ServicePageState extends State<ServicePage> {
  @override
  void initState() {
    super.initState();
    appData.addListener(_update);
  }

  @override
  void dispose() {
    appData.removeListener(_update);
    super.dispose();
  }

  void _update() {
    if (mounted) {
      setState(() {});
    }
  }

  IconData _getIconForService(String serviceName) {
    switch (serviceName) {
      case 'Grooming':
        return Icons.content_cut;
      case 'Pet Boarding':
        return Icons.hotel;
      case 'Veterinary Services':
        return Icons.local_hospital;
      default:
        return Icons.pets;
    }
  }

  Future<void> _showBookingDialog(BuildContext context, Service service) async {
    if (!mounted) return;
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    DateTime? selectedDate = DateTime.now();
    TimeOfDay? selectedTime = TimeOfDay.now();
    final notesController = TextEditingController();

    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) { // Use a different context name to avoid confusion
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Book ${service.name}'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      leading: const Icon(Icons.calendar_today),
                      title: Text(DateFormat.yMMMd().format(selectedDate!)),
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: selectedDate!,
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(const Duration(days: 365)),
                        );
                        if (date != null) {
                          setState(() {
                            selectedDate = date;
                          });
                        }
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.access_time),
                      title: Text(selectedTime!.format(context)),
                      onTap: () async {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: selectedTime!,
                        );
                        if (time != null) {
                          setState(() {
                            selectedTime = time;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: notesController,
                      decoration: const InputDecoration(labelText: 'Pet Name / Notes (Optional)'),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(dialogContext, false), child: const Text('Cancel')),
                ElevatedButton(
                  onPressed: () {
                    if (selectedDate != null && selectedTime != null) {
                      final newAppointment = Appointment(
                        serviceName: service.name,
                        date: selectedDate!,
                        time: selectedTime!,
                        notes: notesController.text,
                      );
                      appData.addAppointment(newAppointment);
                      Navigator.pop(dialogContext, true); // Use dialogContext
                    }
                  },
                  child: const Text('Confirm Appointment'),
                ),
              ],
            );
          },
        );
      },
    );

    if (result == true && mounted) {
      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text('Appointment confirmed!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text('Our Services', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
          ),
          ...appData.services.map((service) {
            final bool isBookable = service.name == 'Grooming' || service.name == 'Pet Boarding';
            return Card(
              child: InkWell(
                onTap: isBookable ? () => _showBookingDialog(context, service) : null,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: ListTile(
                    leading: Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        color: Colors.brown[100],
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Icon(_getIconForService(service.name), color: Colors.white, size: 32),
                    ),
                    title: Text(service.name, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(service.description, maxLines: 2, overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 4),
                        Text('\$${service.price.toStringAsFixed(2)}', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary)),
                      ],
                    ),
                    trailing: isBookable ? const Icon(Icons.chevron_right) : null,
                    isThreeLine: true,
                  ),
                ),
              ),
            );
          }),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text('Scheduled Appointments', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
          ),
          if (appData.appointments.isEmpty)
            const Center(child: Padding(padding: EdgeInsets.all(16.0), child: Text('No appointments scheduled.')))
          else
            ...appData.appointments.map((appointment) {
              return Card(
                child: ListTile(
                  leading: const Icon(Icons.event_available, color: Colors.green),
                  title: Text(appointment.serviceName, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('${DateFormat.yMMMd().format(appointment.date)} at ${appointment.time.format(context)}\n${appointment.notes ?? ''}'),
                  isThreeLine: true,
                ),
              );
            }),
        ],
      ),
    );
  }
}
