import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF1565C0),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1565C0)),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          centerTitle: true,
          backgroundColor: Color(0xFF0D47A1),
          foregroundColor: Colors.white,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        )
      ),
      home: const MainApp(),  
    ) 
  );
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp>{

  final TextEditingController _opcaoController = TextEditingController();
  String? _erroTexto;
  final List<String> _opcoes = [
    "O sucesso não é o destino final, mas a coragem de continuar apesar dos obstáculos.",
    "Não espere por condições perfeitas para começar; o progresso acontece no 'fazer', não no 'planejar'.",
    "A sua maior competição é com a pessoa que você era ontem. Supere-se um pouco a cada dia.",
    "Grandes rotas exigem paciência. Lembre-se: até a árvore mais alta começou como uma pequena semente debaixo da terra.",
    "Erros não são sinais de fracasso, mas provas de que você está tentando e evoluindo.",
    "A disciplina te leva a lugares onde a motivação, sozinha, não consegue chegar.",
    "Você não precisa ver a escada inteira, apenas dar o primeiro passo com confiança.",
    "A energia que você coloca no mundo é a mesma que retorna para você. Escolha ser luz.",
    "Desafios são oportunidades disfarçadas de problemas. Mude o olhar e mude o resultado.",
    "Acreditar que você pode já é metade do caminho percorrido. A outra metade é persistência."
  ];

  final Random _random = Random();

  static const Color _roxo = Color(0xFF1565C0);
  static const Color _roxoClaro = Color(0xFFE3F2FD);
  static const Color _roxoMedia = Color(0xFF90CAF9);
  static const Color _cinza = Color(0xFF616161);
  static const Color _vermelho = Color(0xFFD32F2F);
  static const Color _verde = Color(0xFF2E7D32);

  void _sortear(){
    if(_opcoes.isEmpty || _opcoes.length < 2){
      _mostrarErro("Adicione ao menos 2 opções para sortear!!");
      return;
    }

    final int indice = _random.nextInt(_opcoes.length);
    final String sorteado = _opcoes[indice];

    _mostrarResultado(sorteado);
  }

  void _mostrarErro(String mensagem){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(mensagem)),
          ],
        ),
        backgroundColor: _vermelho,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 5),
      ),
    );
  }

  void _mostrarSucesso(String opcao){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text('"$opcao" adicionado')),
          ],
        ),
        backgroundColor: _verde,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _adicionarOpcao(){
    final texto = _opcaoController.text.trim();
    if (texto.isEmpty) {
      setState(() => _erroTexto = 'Digite ao menos uma opção');
      return;
    }

    if(_opcoes.contains(texto)){
      setState(() => _erroTexto = 'Essa opção já foi adicionada');
      return;
    }
    setState(() {
      _opcoes.add(texto);
      _erroTexto = null;
      _opcaoController.clear();
    });
    _mostrarSucesso(texto);
  }

  void _removerOpcao(int index){
    setState(() => _opcoes.removeAt(index));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _roxoClaro,

      appBar: AppBar(
        title: const Text('Frases motivacionais'),
        actions: [
          if (_opcoes.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep),
              tooltip: 'Limpar tudo',
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Limpar lista?'),
                    content: const Text('Todas as opções serão removidas.'),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar')),
                      ElevatedButton(
                        onPressed: () {
                          setState(() => _opcoes.clear());
                          Navigator.pop(ctx);
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: _vermelho, foregroundColor: Colors.white),
                        child: const Text('Limpar'),
                      ),
                    ],
                  ),
                );
              },
            ),
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text('${_opcoes.length} opções', style: const TextStyle(color: Colors.white, fontSize: 13)),
              ),
            ),
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Image.network(
                'https://images.pexels.com/photos/302899/pexels-photo-302899.jpeg',
                height: 200,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 20),

            const SizedBox(height: 24),

            ElevatedButton.icon(
              onPressed: _opcoes.length >= 2 ? _sortear : null,
              icon: const Icon(Icons.shuffle, size: 22),
              label: Text(
                _opcoes.length < 2
                    ? 'Adicione ${2 - _opcoes.length} opção(ões)'
                    : 'SORTEAR',
                style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, letterSpacing: 1),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: _roxo,
                foregroundColor: Colors.white,
                disabledBackgroundColor: const Color(0xFFBBBBBB),
                disabledForegroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 18),
                elevation: 4,
                shadowColor: _roxo.withOpacity(0.4),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  void _mostrarResultado(String resultado) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          backgroundColor: Colors.white,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              Container(
                width: 80,
                height: 80,
                decoration: const BoxDecoration(
                  color: _roxoMedia,
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Text('🎉', style: TextStyle(fontSize: 40)),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'A decisão foi tomada!',
                style: TextStyle(fontSize: 14, color: _cinza),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                resultado,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: _roxo,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                Future.delayed(const Duration(milliseconds: 200), _sortear);
              },
              child: const Text('Sortear novamente', style: TextStyle(color: _cinza)),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(dialogContext),
              style: ElevatedButton.styleFrom(
                backgroundColor: _roxo,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Ótimo!'),
            ),
          ],
        );
      },
    );
  }
}