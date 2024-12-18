import 'package:flutter/material.dart';

import 'button_add_services.dart';

Widget buildServiceInput(
  int index,
  List<Map<String, dynamic>> services,
  VoidCallback onChange,
) {
  return Column(
    children: [
      Row(
        children: [
          Expanded(
            child: TextFormField(
              initialValue: services[index]['name'] ?? "",
              onChanged: (value) => services[index]['name'] = value,
              decoration: const InputDecoration(labelText: 'Service Name'),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextFormField(
              initialValue: services[index]['price'].toString(),
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
      ),
    ],
  );
}

class ServicesInputWidget extends StatelessWidget {
  const ServicesInputWidget(
      {super.key, required this.services, required this.onChange});

  final List<Map<String, dynamic>> services;
  final Function(List<Map<String, dynamic>>) onChange;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: Colors.white,
          ),
          child: Column(
            children: [
              const Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  'Services and Prices',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              ListView.builder(
                shrinkWrap: true, // Ensures the list fits within the column.
                itemCount: services.length, // Number of services.
                itemBuilder: (context, index) {
                  return buildServiceInput(index, services, () {
                    onChange(List.from(services));
                  });
                },
              ),
              const SizedBox(
                height: 20,
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: ButtonAddServices(
                  services: services,
                  onChange: () {
                    onChange(List.from(services));
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
