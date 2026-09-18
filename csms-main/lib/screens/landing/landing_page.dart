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
  bool _scrolled = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      final scrolled = _scrollController.offset > 8;
      if (scrolled != _scrolled) setState(() => _scrolled = scrolled);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

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
              scrolled: _scrolled,
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
  final bool scrolled;
  final VoidCallback onMenu, onAbout, onContact;
  const _Header(
      {required this.wide,
      required this.scrolled,
      required this.onMenu,
      required this.onAbout,
      required this.onContact});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        boxShadow: scrolled
            ? [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 12, offset: const Offset(0, 3))]
            : [],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                  colors: [AppColors.accent, AppColors.brownDeep],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.local_cafe_rounded, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          const Text('Overnight Cafe',
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 19, color: AppColors.darkBrown, letterSpacing: -0.3)),
          const Spacer(),
          if (wide) ...[
            TextButton(onPressed: () {}, child: const Text('Home')),
            TextButton(onPressed: onAbout, child: const Text('About')),
            TextButton(onPressed: onMenu, child: const Text('Menu')),
            TextButton(onPressed: onContact, child: const Text('Contact')),
            const SizedBox(width: 10),
            OutlinedButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginScreen())), child: const Text('Login')),
            const SizedBox(width: 10),
            ElevatedButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterScreen())), child: const Text('Register')),
          ] else
            PopupMenuButton<String>(
              icon: const Icon(Icons.menu_rounded, color: AppColors.darkBrown),
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
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 88),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.darkBrown, AppColors.brown, AppColors.brownDeep],
          stops: [0.0, 0.55, 1.0],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: -40,
            left: -40,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.accent.withValues(alpha: 0.12)),
            ),
          ),
          Positioned(
            bottom: -50,
            right: -30,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withValues(alpha: 0.05)),
            ),
          ),
          Column(
            children: [
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
                ),
                child: const Text('☕', style: TextStyle(fontSize: 46)),
              ),
              const SizedBox(height: 20),
              const Text('Overnight Cafe',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 42, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: -0.8)),
              const SizedBox(height: 10),
              const Text('Every cup tells a story.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 17, color: AppColors.beige, fontStyle: FontStyle.italic)),
              const SizedBox(height: 14),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 520),
                  child: const Text(
                    'A cozy neighborhood café serving handcrafted coffee, comforting snacks, and a warm place to sit and stay a while.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70, height: 1.6, fontSize: 15.5),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Wrap(
                spacing: 14,
                runSpacing: 12,
                alignment: WrapAlignment.center,
                children: [
                  FilledButton.icon(
                    style: FilledButton.styleFrom(backgroundColor: AppColors.accent),
                    onPressed: onViewMenu,
                    icon: const Icon(Icons.menu_book_rounded),
                    label: const Text('View Menu'),
                  ),
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white, side: const BorderSide(color: Colors.white54, width: 1.4)),
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginScreen())),
                    icon: const Icon(Icons.login_rounded),
                    label: const Text('Login'),
                  ),
                ],
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
    return Container(
      width: 230,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.cream,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: AppColors.beige, borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: AppColors.brown, size: 20),
          ),
          const SizedBox(height: 10),
          Text(title, style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.darkBrown)),
          const SizedBox(height: 2),
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
                child: InkWell(
                  borderRadius: BorderRadius.circular(18),
                  onTap: () {},
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: [AppColors.beige, AppColors.beigeDark],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          alignment: Alignment.center,
                          child: Text(p.emoji, style: const TextStyle(fontSize: 26)),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(p.name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5)),
                              const SizedBox(height: 2),
                              Text(p.description,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
                              const SizedBox(height: 6),
                              Text(peso(p.price),
                                  style: const TextStyle(color: AppColors.accentDark, fontWeight: FontWeight.w800)),
                            ],
                          ),
                        ),
                      ],
                    ),
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
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.local_cafe_rounded, color: AppColors.accent, size: 20),
          ),
          const SizedBox(height: 12),
          const Text('Overnight Cafe', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16)),
          const SizedBox(height: 8),
          const Text('Calamba, Laguna, Philippines · 0917-000-0000 · hello@kapetkwento.com',
              style: TextStyle(color: Colors.white70, fontSize: 12)),
          const SizedBox(height: 14),
          const Divider(color: Colors.white12, height: 1),
          const SizedBox(height: 14),
          const Text('© 2026 Overnight Cafe. All rights reserved.', style: TextStyle(color: Colors.white38, fontSize: 11)),
        ],
      ),
    );
  }
}
