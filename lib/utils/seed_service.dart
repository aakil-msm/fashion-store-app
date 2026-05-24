import 'package:cloud_firestore/cloud_firestore.dart';

/// ONE-TIME seed script.
/// 1. Call SeedService.seedProducts() once from main() after Firebase.initializeApp()
/// 2. Run app → check Firestore console → 20 products appear
/// 3. Remove the call from main.dart — done forever.

class SeedService {
  static final _col = FirebaseFirestore.instance.collection('products');

  static Future<void> seedProducts() async {
    // Clear any old incorrect products first
    final existing = await _col.get();
    if (existing.docs.isNotEmpty) {
      final deleteBatch = FirebaseFirestore.instance.batch();
      for (final doc in existing.docs) {
        deleteBatch.delete(doc.reference);
      }
      await deleteBatch.commit();
      print('[SeedService] Cleared old products.');
    }

    print('[SeedService] Seeding 20 products into Firestore...');
    final batch = FirebaseFirestore.instance.batch();

    for (final p in _products) {
      final ref = _col.doc();
      batch.set(ref, p);
    }

    await batch.commit();
    print('[SeedService] Done! 20 products written to Firestore.');
  }

  // ── What each image actually shows ────────────────────────────────────────
  // im1  → Backpack                  (accessories)
  // im2  → Men's raglan t-shirt      (men's clothing)
  // im3  → Men's khaki jacket        (men's clothing)
  // im4  → Men's long-sleeve tee     (men's clothing)
  // im5  → Dragon silver bracelet    (accessories)
  // im6  → Diamond eternity ring     (accessories)
  // im7  → Halo diamond ring set     (accessories)
  // im8  → Rose gold ring pair       (accessories)
  // im9–im14 → Electronics — NOT USED (wrong for a fashion store)
  // im15 → Women's outdoor jacket    (women's clothing)
  // im16 → Women's leather jacket    (women's clothing)
  // im17 → Women's trench coat       (women's clothing)
  // im18 → Women's dolman top        (women's clothing)
  // im19 → Women's red v-neck tee    (women's clothing)
  // im20 → Women's graphic tee       (women's clothing)

  static final List<Map<String, dynamic>> _products = [

    // ── ACCESSORIES (5) ──────────────────────────────────────────────────────
    {
      'title': 'Urban Fold-Top Backpack',
      'description':
          'A sturdy and minimalist fold-top backpack made from water-resistant canvas. '
          'Features padded shoulder straps, a main compartment with laptop sleeve, and a front '
          'zip pocket. Perfect for commuting, travel, or campus.',
      'price': 54.99,
      'category': 'accessories',
      'imageAsset': 'images/products/im1.png',
      'ratingRate': 4.6,
      'ratingCount': 312,
    },
    {
      'title': 'Dragon Scale Silver Bracelet',
      'description':
          'A bold and intricate dragon-motif bracelet crafted from 925 sterling silver '
          'with gold-tone accent details. Features a secure clasp closure. A statement piece '
          'for those who love unique artisan jewellery.',
      'price': 39.99,
      'category': 'accessories',
      'imageAsset': 'images/products/im5.png',
      'ratingRate': 4.4,
      'ratingCount': 87,
    },
    {
      'title': 'Diamond Eternity Band Ring',
      'description':
          'A delicate and timeless diamond eternity band set in polished white gold. '
          'Encrusted with sparkling round-cut diamonds, perfect as a wedding band, '
          'anniversary gift, or everyday luxury accessory.',
      'price': 129.99,
      'category': 'accessories',
      'imageAsset': 'images/products/im6.png',
      'ratingRate': 4.8,
      'ratingCount': 204,
    },
    {
      'title': 'Halo Diamond Bridal Ring Set',
      'description':
          'A stunning halo diamond engagement ring paired with a matching wedding band. '
          'The cushion-cut centre stone is surrounded by a halo of pavé diamonds for maximum '
          'sparkle. Set in white gold for a classic bridal look.',
      'price': 199.99,
      'category': 'accessories',
      'imageAsset': 'images/products/im7.png',
      'ratingRate': 4.9,
      'ratingCount': 156,
    },
    {
      'title': 'Rose Gold Couple Ring Set',
      'description':
          'A matching pair of sleek rose gold bands, perfect for couples. The smooth '
          'polished finish and minimalist design make these rings versatile for everyday wear '
          'or special occasions. Available in multiple sizes.',
      'price': 49.99,
      'category': 'accessories',
      'imageAsset': 'images/products/im8.png',
      'ratingRate': 4.5,
      'ratingCount': 173,
    },

    // ── MEN'S CLOTHING (6) ───────────────────────────────────────────────────
    {
      'title': 'Raglan Henley T-Shirt',
      'description':
          'A stylish raglan-sleeve henley tee with contrast colour-blocked sleeves. '
          'Made from a soft cotton blend with a three-button placket and a relaxed fit. '
          'Great for casual outings and weekend wear.',
      'price': 22.99,
      'category': "men's clothing",
      'imageAsset': 'images/products/im2.png',
      'ratingRate': 4.3,
      'ratingCount': 241,
    },
    {
      'title': 'Casual Field Jacket',
      'description':
          'A rugged yet refined field jacket in a classic khaki tone. Features a zip-up '
          'front, multiple utility pockets, a stand collar, and epaulette shoulder details. '
          'Lightweight enough for year-round wear.',
      'price': 64.99,
      'category': "men's clothing",
      'imageAsset': 'images/products/im3.png',
      'ratingRate': 4.6,
      'ratingCount': 318,
    },
    {
      'title': 'Long Sleeve V-Neck Tee',
      'description':
          'A premium long-sleeve V-neck T-shirt in versatile slate blue. Crafted from a '
          'soft cotton-modal blend for all-day comfort, with a slim fit that pairs well '
          'with jeans or chinos.',
      'price': 18.99,
      'category': "men's clothing",
      'imageAsset': 'images/products/im4.png',
      'ratingRate': 4.2,
      'ratingCount': 189,
    },
    {
      'title': 'Baseball Raglan Crew Tee',
      'description':
          'A laid-back baseball-style tee with a crew neck and 3/4 contrast sleeves. '
          'Ideal for everyday casual wear. The breathable cotton fabric and relaxed cut '
          'make it a go-to wardrobe staple.',
      'price': 19.99,
      'category': "men's clothing",
      'imageAsset': 'images/products/im2.png',
      'ratingRate': 4.1,
      'ratingCount': 122,
    },
    {
      'title': 'Lightweight Utility Jacket',
      'description':
          'A versatile lightweight jacket for the modern man. Clean silhouette with zip '
          'closure, side hand pockets, and a removable hood. Suitable for layering in '
          'spring and autumn.',
      'price': 72.99,
      'category': "men's clothing",
      'imageAsset': 'images/products/im3.png',
      'ratingRate': 4.5,
      'ratingCount': 97,
    },
    {
      'title': 'Slim Fit Thermal Long Sleeve',
      'description':
          'A comfortable thermal long-sleeve shirt that works as a base layer or '
          'standalone top. The soft ribbed fabric retains warmth without bulk, making it '
          'ideal for cooler days.',
      'price': 24.99,
      'category': "men's clothing",
      'imageAsset': 'images/products/im4.png',
      'ratingRate': 4.4,
      'ratingCount': 145,
    },

    // ── WOMEN'S CLOTHING (9) ─────────────────────────────────────────────────
    {
      'title': "Women's 3-in-1 Outdoor Jacket",
      'description':
          'A high-performance waterproof outdoor jacket in bold purple. Features a '
          'detachable hood, fleece lining, multiple zip pockets, and adjustable cuffs. '
          'Perfect for hiking, travel, or rainy city days.',
      'price': 79.99,
      'category': "women's clothing",
      'imageAsset': 'images/products/im15.png',
      'ratingRate': 4.7,
      'ratingCount': 284,
    },
    {
      'title': 'Faux Leather Moto Jacket',
      'description':
          'An edgy faux leather moto jacket with a removable drawstring hood. Features '
          'a zip-up front, quilted sleeve panels, and side zip pockets. The ultimate '
          'statement outer layer for any wardrobe.',
      'price': 69.99,
      'category': "women's clothing",
      'imageAsset': 'images/products/im16.png',
      'ratingRate': 4.6,
      'ratingCount': 367,
    },
    {
      'title': 'Navy Drawstring Trench Coat',
      'description':
          'A chic navy trench coat with a striped lining and adjustable drawstring waist. '
          'Button-snap epaulettes, front flap pockets, and a relaxed silhouette make this '
          'perfect for effortless smart-casual dressing.',
      'price': 84.99,
      'category': "women's clothing",
      'imageAsset': 'images/products/im17.png',
      'ratingRate': 4.5,
      'ratingCount': 193,
    },
    {
      'title': 'Dolman Sleeve Ruched Top',
      'description':
          'A flattering dolman-sleeve top with ruched side detailing that cinches at the '
          'waist. Made from stretchy jersey fabric, it drapes beautifully and works '
          'dressed up or down.',
      'price': 21.99,
      'category': "women's clothing",
      'imageAsset': 'images/products/im18.png',
      'ratingRate': 4.3,
      'ratingCount': 208,
    },
    {
      'title': 'Active V-Neck Performance Tee',
      'description':
          'A lightweight V-neck performance tee in vibrant red. Crafted from '
          'moisture-wicking fabric that keeps you dry and comfortable during workouts '
          'or casual wear.',
      'price': 16.99,
      'category': "women's clothing",
      'imageAsset': 'images/products/im19.png',
      'ratingRate': 4.4,
      'ratingCount': 276,
    },
    {
      'title': '"Be Kind" Graphic V-Neck Tee',
      'description':
          'A soft and comfortable graphic tee featuring a hand-lettered "Be Kind" design. '
          'Made from a cotton blend with a relaxed fit. Pairs with jeans, shorts, or skirts '
          'for an effortless casual look.',
      'price': 17.99,
      'category': "women's clothing",
      'imageAsset': 'images/products/im20.png',
      'ratingRate': 4.6,
      'ratingCount': 431,
    },
    {
      'title': 'Fleece-Lined Winter Parka',
      'description':
          'Stay warm in style with this fleece-lined waterproof parka. The adjustable '
          'hood and drawstring waist create a flattering silhouette, while deep zip pockets '
          'and an inner lining ensure practical warmth on cold days.',
      'price': 89.99,
      'category': "women's clothing",
      'imageAsset': 'images/products/im15.png',
      'ratingRate': 4.8,
      'ratingCount': 152,
    },
    {
      'title': 'Classic Biker Jacket',
      'description':
          'A timeless faux leather biker jacket with a zip-up front, structured shoulders, '
          'and silver-tone hardware. The fitted silhouette makes this jacket an iconic '
          'addition to any wardrobe.',
      'price': 74.99,
      'category': "women's clothing",
      'imageAsset': 'images/products/im16.png',
      'ratingRate': 4.5,
      'ratingCount': 219,
    },
    {
      'title': 'Casual Oversized Tee',
      'description':
          'A breezy oversized tee in clean white, perfect for layering or wearing solo. '
          'The drop-shoulder design and soft jersey fabric make it an effortlessly cool '
          'wardrobe essential for warm days.',
      'price': 14.99,
      'category': "women's clothing",
      'imageAsset': 'images/products/im18.png',
      'ratingRate': 4.2,
      'ratingCount': 334,
    },
  ];
}