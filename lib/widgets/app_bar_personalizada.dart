import 'package:flutter/material.dart';
import 'package:ingresso_app_flutter/services/app_preferences_service.dart';
import '../models/usuario.dart';

class AppBarPersonalizada extends StatelessWidget
    implements PreferredSizeWidget {
  final String titulo;
  final Usuario usuarioLogado;
  final VoidCallback aoFazerLogout;

  const AppBarPersonalizada({
    super.key,
    required this.titulo,
    required this.usuarioLogado,
    required this.aoFazerLogout,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Text(titulo),
      actions: [
        Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {
              Scaffold.of(context).openEndDrawer();
            },
            tooltip: 'Perfil do usuário',
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class DrawerPerfilUsuario extends StatelessWidget {
  final Usuario usuarioLogado;
  final VoidCallback aoFazerLogout;

  const DrawerPerfilUsuario({
    super.key,
    required this.usuarioLogado,
    required this.aoFazerLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundColor: Colors.white,
                  child: Text(
                    usuarioLogado.nome.split(' ').first[0].toUpperCase(),
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  usuarioLogado.nome,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  usuarioLogado.email,
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Configurações',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 12),
                ValueListenableBuilder<bool>(
                  valueListenable: AppPreferencesService.darkModeNotifier,
                  builder: (context, isDarkMode, _) {
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(
                        isDarkMode
                            ? Icons.light_mode_outlined
                            : Icons.dark_mode_outlined,
                      ),
                      title: const Text('Tema'),
                      subtitle: Text(
                        isDarkMode
                            ? 'Tema escuro ativado'
                            : 'Tema claro ativado',
                        style: const TextStyle(fontSize: 12),
                      ),
                      onTap: AppPreferencesService.toggleDarkMode,
                    );
                  },
                ),
                const SizedBox(height: 8),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.logout),
                  title: const Text('Sair'),
                  subtitle: const Text(
                    'Fazer logout da conta',
                    style: TextStyle(fontSize: 12),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    aoFazerLogout();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
