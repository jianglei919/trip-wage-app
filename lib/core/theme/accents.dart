import 'package:flutter/material.dart';

class Accent {
  const Accent(this.bg, this.fg);
  final Color bg;
  final Color fg;

  /// 用于深色模式：以前景色降透明度作背景，前景色变为浅色（bg）
  Color bgFor(Brightness b) =>
      b == Brightness.dark ? fg.withValues(alpha: 0.18) : bg;
  Color fgFor(Brightness b) => b == Brightness.dark ? bg : fg;
}

/// 项目里所有 accent 一处定义，方便统一调色
class AppAccents {
  static const blue = Accent(Color(0xFFE3F2FD), Color(0xFF1565C0));
  static const purple = Accent(Color(0xFFF3E5F5), Color(0xFF7B1FA2));
  static const orange = Accent(Color(0xFFFFF3E0), Color(0xFFE65100));
  static const teal = Accent(Color(0xFFE0F2F1), Color(0xFF00695C));
  static const green = Accent(Color(0xFFE8F5E9), Color(0xFF2E7D32));
  static const pink = Accent(Color(0xFFFCE4EC), Color(0xFFC2185B));
  static const amber = Accent(Color(0xFFFFF8E1), Color(0xFFF57F17));
  static const indigo = Accent(Color(0xFFE8EAF6), Color(0xFF283593));
}

/// 支付方式 → 颜色 + 图标
class PaymentStyle {
  const PaymentStyle(this.icon, this.accent);
  final IconData icon;
  final Accent accent;

  static const _styles = <String, PaymentStyle>{
    'online': PaymentStyle(Icons.cloud_outlined, AppAccents.blue),
    'card': PaymentStyle(Icons.credit_card, AppAccents.purple),
    'cash': PaymentStyle(Icons.payments_outlined, AppAccents.green),
    'mixed': PaymentStyle(Icons.sync_alt, AppAccents.orange),
  };

  static PaymentStyle of(String paymentType) =>
      _styles[paymentType] ?? const PaymentStyle(Icons.help_outline, AppAccents.indigo);
}
