import 'package:flutter/material.dart';

Widget buildServiceInput(
  int index,
  List<Map<String, dynamic>> services,
  VoidCallback onChange,
) {
  return Row(
    children: [
      Expanded(
        child: TextField(
          onChanged: (value) => services[index]['name'] = value,
          decoration: const InputDecoration(labelText: 'Service Name'),
        ),
      ),
      const SizedBox(width: 10),
      Expanded(
        child: TextField(
          onChanged: (value) =>
              services[index]['price'] = double.tryParse(value) ?? 0.0,
          decoration: const InputDecoration(labelText: 'Price'),
          keyboardType: TextInputType.number,
        ),
      ),
      IconButton(
        icon: const Icon(Icons.remove),
        onPressed: () {
          if (index < services.length) {
            services.removeAt(index);
            onChange();
          }
        },
      ),
    ],
  );
}

class ServicesInputWidget extends StatelessWidget {
  const ServicesInputWidget(
      {super.key, required this.services, required this.onChange});

  final List<Map<String, dynamic>> services;
  final VoidCallback onChange;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true, // Ensures the list fits within the column.
      itemCount: services.length, // Number of services.
      itemBuilder: (context, index) {
        return buildServiceInput(index, services, () {
          onChange();
        });
      },
    );
  }
}
