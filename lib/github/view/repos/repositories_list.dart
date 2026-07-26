import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:portfolio/github/models/portfolio_data.dart';
import 'package:portfolio/github/utils.dart';

class RepositoriesList extends StatelessWidget {
  static const routeName = '/repositories';
  final List<PortfolioRepository> repositories;
  final double cardWidth;

  const RepositoriesList({
    super.key,
    required this.repositories,
    required this.cardWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            "Public Repos",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 16.0),
        StaggeredGrid.count(
          crossAxisCount: 2,
          children: repositories
              .map((repo) => SizedBox(
                    width: cardWidth,
                    child: _RepositoryCard(repository: repo),
                  ))
              .toList(),
        ),
      ],
    );
  }
}

class _RepositoryCard extends StatelessWidget {
  final PortfolioRepository repository;

  const _RepositoryCard({required this.repository});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => openExternalUrl(context, repository.link),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.yellow),
                  Text(" ${repository.stars}"),
                  const SizedBox(width: 8),
                  Expanded(child: Text(repository.name)),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(repository.description ?? 'No Description'),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: repository.hasDemo
                      ? () => openExternalUrl(context, repository.demoUrl)
                      : null,
                  child: const Text('Demo'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
