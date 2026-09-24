import 'package:flutter/material.dart';

class DocumentUploadScreen extends StatefulWidget {
  const DocumentUploadScreen({super.key});

  @override
  State<DocumentUploadScreen> createState() => _DocumentUploadScreenState();
}

class _DocumentUploadScreenState extends State<DocumentUploadScreen> {
  final List<_Document> _documents = [
    const _Document(
      name: 'Blood Test Report',
      type: 'Laboratory Report',
      date: '20 Sep 2026',
      status: 'Processed',
      icon: Icons.science_outlined,
    ),
    const _Document(
      name: 'Prescription',
      type: 'Prescription',
      date: '18 Sep 2026',
      status: 'Processed',
      icon: Icons.medication_outlined,
    ),
  ];

  void _showUploadOptions() {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.upload_file_rounded),
                  title: const Text('Upload a document'),
                  subtitle: const Text('Choose a PDF or image'),
                  onTap: () {
                    Navigator.pop(context);
                    _addDocument('Uploaded Document');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.document_scanner_outlined),
                  title: const Text('Scan a document'),
                  subtitle: const Text('Use your camera'),
                  onTap: () {
                    Navigator.pop(context);
                    _addDocument('Scanned Document');
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _addDocument(String name) {
    setState(() {
      _documents.insert(
        0,
        _Document(
          name: name,
          type: 'Medical Document',
          date: 'Just now',
          status: 'Processing',
          icon: Icons.description_outlined,
        ),
      );
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;

      setState(() {
        if (_documents.isNotEmpty) {
          _documents[0] = _Document(
            name: _documents[0].name,
            type: _documents[0].type,
            date: _documents[0].date,
            status: 'Processed',
            icon: _documents[0].icon,
          );
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: const Text('Documents'),
        centerTitle: false,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showUploadOptions,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add document'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.folder_special_outlined,
                  size: 32,
                  color: colorScheme.onPrimaryContainer,
                ),
                const SizedBox(height: 16),
                Text(
                  'Your medical documents',
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(
                        color: colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Upload previous reports and prescriptions to keep your clinical history organized.',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(
                        color: colorScheme.onPrimaryContainer,
                      ),
                ),
                const SizedBox(height: 20),
                FilledButton.icon(
                  onPressed: _showUploadOptions,
                  icon: const Icon(Icons.upload_rounded),
                  label: const Text('Upload document'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          Text(
            'Recent documents',
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 12),
          if (_documents.isEmpty)
            _EmptyDocuments(
              onAdd: _showUploadOptions,
            )
          else
            ..._documents.map(
              (document) => _DocumentCard(
                document: document,
                onTap: () {},
              ),
            ),
        ],
      ),
    );
  }
}

class _DocumentCard extends StatelessWidget {
  final _Document document;
  final VoidCallback onTap;

  const _DocumentCard({
    required this.document,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final isProcessing = document.status == 'Processing';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      color: colorScheme.surfaceContainerLow,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  document.icon,
                  color: colorScheme.onSecondaryContainer,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      document.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      document.type,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Text(
                          document.date,
                          style: Theme.of(context)
                              .textTheme
                              .labelMedium
                              ?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          width: 4,
                          height: 4,
                          decoration: BoxDecoration(
                            color: colorScheme.outline,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          document.status,
                          style: Theme.of(context)
                              .textTheme
                              .labelMedium
                              ?.copyWith(
                                color: isProcessing
                                    ? colorScheme.primary
                                    : colorScheme.onSurfaceVariant,
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.chevron_right_rounded),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyDocuments extends StatelessWidget {
  final VoidCallback onAdd;

  const _EmptyDocuments({
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        children: [
          Icon(
            Icons.folder_open_outlined,
            size: 52,
            color: colorScheme.outline,
          ),
          const SizedBox(height: 12),
          Text(
            'No documents yet',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 6),
          Text(
            'Upload a medical document to get started.',
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: onAdd,
            icon: const Icon(Icons.add_rounded),
            label: const Text('Add document'),
          ),
        ],
      ),
    );
  }
}

class _Document {
  final String name;
  final String type;
  final String date;
  final String status;
  final IconData icon;

  const _Document({
    required this.name,
    required this.type,
    required this.date,
    required this.status,
    required this.icon,
  });
}