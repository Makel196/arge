/// Zod-like validation utility for Flutter forms.
///
/// Example usage:
/// ```dart
/// final validator = Z.string().min(3).email().build();
/// String? error = validator("test");
/// ```
library;

class Z {
  static ZString string() => ZString();
  static ZNumber number() => ZNumber();
}

abstract class ZType<T> {
  final List<String? Function(T?)> _validators = [];
  bool _isOptional = false;

  ZType<T> optional() {
    _isOptional = true;
    return this;
  }

  ZType<T> custom(bool Function(T?) predicate, {String? message}) {
    _validators.add((value) {
      if (!predicate(value)) {
        return message ?? 'Geçersiz değer';
      }
      return null;
    });
    return this;
  }

  String? Function(T?) build() {
    return (T? value) {
      if (_isOptional &&
          (value == null || (value is String && value.isEmpty))) {
        return null;
      }
      if (!_isOptional && value == null) {
        return 'Bu alan zorunludur';
      }

      for (final validator in _validators) {
        final result = validator(value);
        if (result != null) return result;
      }
      return null;
    };
  }
}

class ZString extends ZType<String> {
  ZString min(int length, {String? message}) {
    _validators.add((value) {
      if (value != null && value.length < length) {
        return message ?? 'En az $length karakter olmalı';
      }
      return null;
    });
    return this;
  }

  ZString max(int length, {String? message}) {
    _validators.add((value) {
      if (value != null && value.length > length) {
        return message ?? 'En fazla $length karakter olmalı';
      }
      return null;
    });
    return this;
  }

  ZString email({String? message}) {
    _validators.add((value) {
      if (value != null) {
        final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
        if (!emailRegex.hasMatch(value)) {
          return message ?? 'Geçerli bir e-posta adresi giriniz';
        }
      }
      return null;
    });
    return this;
  }

  ZString url({String? message}) {
    _validators.add((value) {
      if (value != null) {
        try {
          final uri = Uri.parse(value);
          if (!uri.hasScheme || !uri.hasAuthority) {
            return message ?? 'Geçerli bir URL giriniz';
          }
        } catch (_) {
          return message ?? 'Geçerli bir URL giriniz';
        }
      }
      return null;
    });
    return this;
  }
}

class ZNumber extends ZType<num> {
  ZNumber min(num min, {String? message}) {
    _validators.add((value) {
      if (value != null && value < min) {
        return message ?? 'Değer $min veya daha büyük olmalı';
      }
      return null;
    });
    return this;
  }

  ZNumber max(num max, {String? message}) {
    _validators.add((value) {
      if (value != null && value > max) {
        return message ?? 'Değer $max veya daha küçük olmalı';
      }
      return null;
    });
    return this;
  }
}
