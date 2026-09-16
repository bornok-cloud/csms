import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../services/app_data.dart';
import '../auth/login_screen.dart';
import '../auth/register_screen.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});
  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final _menuKey = GlobalKey();
  final _aboutKey = GlobalKey();
  final _contactKey = GlobalKey();
  final _scrollController = ScrollController();

  void _scrollTo(GlobalKey key) {
    final ctx = key.currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(ctx, duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
    }
  }

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.of(context).size.width >= 800;
    final products = AppData.instance.products;

    return Scaffold(
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            _Header(
              wide: wide,
              onMenu: () => _scrollTo(_menuKey),
              onAbout: () => _scrollTo(_aboutKey),
              onContact: () => _scrollTo(_contactKey),
            ),
            _Hero(onViewMenu: () => _scrollTo(_menuKey)),
            Container(key: _aboutKey, child: const _AboutSection()),
            Container(key: _menuKey, child: _MenuSection(products: products)),
            Container(key: _contactKey, child: const _ContactFooter()),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final bool wide;
  final VoidCallback onMenu, onAbout, onContact;
  const _Header({required this.wide, required this.onMenu, required this.onAbout, required this.onContact});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.cardWhite,
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: AppColors.beige,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.local_cafe, color: AppColors.brown, size: 22),
          ),
          const SizedBox(width: 12),
          const Text('Overnight Cafe', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19, color: AppColors.darkBrown)),
          const Spacer(),
          if (wide) ...[
            TextButton(onPressed: () {}, child: const Text('Home')),
            TextButton(onPressed: onAbout, child: const Text('About')),
            TextButton(onPressed: onMenu, child: const Text('Menu')),
            TextButton(onPressed: onContact, child: const Text('Contact')),
            const SizedBox(width: 8),
            OutlinedButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginScreen())), child: const Text('Login')),
            const SizedBox(width: 8),
            ElevatedButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterScreen())), child: const Text('Register')),
          ] else
            PopupMenuButton<String>(
              icon: const Icon(Icons.menu, color: AppColors.darkBrown),
              onSelected: (v) {
                if (v == 'about') onAbout();
                if (v == 'menu') onMenu();
                if (v == 'contact') onContact();
                if (v == 'login') Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
                if (v == 'register') Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterScreen()));
              },
              itemBuilder: (ctx) => const [
                PopupMenuItem(value: 'about', child: Text('About')),
                PopupMenuItem(value: 'menu', child: Text('Menu')),
                PopupMenuItem(value: 'contact', child: Text('Contact')),
                PopupMenuItem(value: 'login', child: Text('Login')),
                PopupMenuItem(value: 'register', child: Text('Register')),
              ],
            ),
        ],
      ),
    );
  }
}

class _Hero extends StatelessWidget {
  final VoidCallback onViewMenu;
  const _Hero({required this.onViewMenu});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 76),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.darkBrown, AppColors.brown],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: const Text('☕', style: TextStyle(fontSize: 48)),
          ),
          const SizedBox(height: 16),
          const Text('Overnight Cafe', textAlign: TextAlign.center, style: TextStyle(fontSize: 38, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 8),
          const Text('Every cup tells a story.', textAlign: TextAlign.center, style: TextStyle(fontSize: 17, color: AppColors.beige, fontStyle: FontStyle.italic)),
          const SizedBox(height: 12),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'A cozy neighborhood café serving handcrafted coffee, comforting snacks, and a warm place to sit and stay a while.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70, height: 1.5),
            ),
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            alignment: WrapAlignment.center,
            children: [
              ElevatedButton.icon(onPressed: onViewMenu, icon: const Icon(Icons.menu_book), label: const Text('View Menu')),
              OutlinedButton.icon(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginScreen())),
                icon: const Icon(Icons.login),
                label: const Text('Login'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AboutSection extends StatelessWidget {
  const _AboutSection();
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.cardWhite,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
      child: Column(
        children: [
          const Text('About Us', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: AppColors.darkBrown)),
          const SizedBox(height: 16),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 700),
            child: Text(
              'Overnight Cafe started in 2019 as a small corner stall serving family-recipe brews. '
              'Today we\'re a full café known for quality beans, fresh pastries, and a welcoming space '
              'for students, professionals, and friends catching up over coffee.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textMuted, height: 1.5),
            ),
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 32,
            runSpacing: 16,
            alignment: WrapAlignment.center,
            children: const [
              _InfoTile(icon: Icons.access_time, title: 'Opening Hours', value: 'Mon–Sun, 7:00 AM – 9:00 PM'),
              _InfoTile(icon: Icons.location_on_outlined, title: 'Location', value: 'Calamba, Laguna, Philippines'),
              _InfoTile(icon: Icons.phone_outlined, title: 'Contact', value: '0917-000-0000'),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String title, value;
  const _InfoTile({required this.icon, required this.title, required this.value});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      child: Column(
        children: [
          Icon(icon, color: AppColors.brown),
          const SizedBox(height: 6),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.darkBrown)),
          Text(value, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.textMuted, fontSize: 13)),
        ],
      ),
    );
  }
}

class _MenuSection extends StatelessWidget {
  final List products;
  const _MenuSection({required this.products});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final cols = width >= 1000 ? 3 : (width >= 650 ? 2 : 1);
    return Container(
      color: AppColors.cream,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
      child: Column(
        children: [
          const Text('Our Menu', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: AppColors.darkBrown)),
          const SizedBox(height: 20),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: products.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: cols, mainAxisExtent: 120, crossAxisSpacing: 16, mainAxisSpacing: 16),
            itemBuilder: (ctx, i) {
              final p = products[i];
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(color: AppColors.beige, borderRadius: BorderRadius.circular(14)),
                        alignment: Alignment.center,
                        child: Text(p.emoji, style: const TextStyle(fontSize: 26)),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(p.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                            Text(p.description, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
                            const SizedBox(height: 4),
                            Text(peso(p.price), style: const TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ContactFooter extends StatelessWidget {
  const _ContactFooter();
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.darkBrown,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: const Column(
        children: [
          Text('Overnight Cafe', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
          SizedBox(height: 6),
          Text('Calamba, Laguna, Philippines · 0917-000-0000 · hello@kapetkwento.com', style: TextStyle(color: Colors.white70, fontSize: 12)),
          SizedBox(height: 6),
          Text('© 2026 Overnight Cafe. All rights reserved.', style: TextStyle(color: Colors.white38, fontSize: 11)),
        ],
      ),
    );
  }
}
