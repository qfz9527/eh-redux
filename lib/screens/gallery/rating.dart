import 'package:eh_redux/models/gallery.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GalleryRating extends StatelessWidget {
  const GalleryRating({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final gallery = Provider.of<Gallery>(context);
    final details = Provider.of<GalleryDetails>(context);
    final padding = MediaQuery.of(context).padding.copyWith(top: 0) +
        const EdgeInsets.all(16);

    return Padding(
      padding: padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _buildTile(
            context: context,
            icon: Icon(Icons.star),
            title: Text('${gallery.rating}'),
            caption:
                Text('Rating (${details?.ratingCount?.toString() ?? '...'})'),
          ),
          _buildTile(
            context: context,
            icon: Icon(Icons.favorite),
            title: Text(details?.favoritesCount?.toString() ?? '...'),
            caption: const Text('Favorited'),
          ),
        ],
      ),
    );
  }

  Widget _buildTile({
    @required BuildContext context,
    @required Icon icon,
    @required Widget title,
    @required Widget caption,
  }) {
    final theme = Theme.of(context);

    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            IconTheme(
              data: IconThemeData(
                color: theme.accentColor,
                size: 20,
              ),
              child: icon,
            ),
            const SizedBox(width: 4),
            DefaultTextStyle(
              style: theme.textTheme.headline6.copyWith(
                fontWeight: FontWeight.bold,
              ),
              child: title,
            ),
          ],
        ),
        const SizedBox(height: 8),
        DefaultTextStyle(
          style: theme.textTheme.caption,
          child: caption,
        ),
      ],
    );
  }
}