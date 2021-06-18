class Validations {
  static String validateName(String value) {
    if (value.isEmpty) return '닉네임이 입력되지 않았습니다.';
    final RegExp nameExp = new RegExp(r'^[A-za-zğüşöçİĞÜŞÖÇ ]+$');
    if (!nameExp.hasMatch(value)) return '알파벳 외의 문자는 입력할 수 없습니다.';
    return null;
  }

  static String validateEmail(String value, [bool isRequried = true]) {
    if (value.isEmpty && isRequried) return '이메일이 입력되지 않았습니다.';
    final RegExp nameExp = new RegExp(
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
    if (!nameExp.hasMatch(value) && isRequried) return '유효하지 않은 이메일 주소입니다';
    return null;
  }

  static String validatePassword(String value) {
    if (value.isEmpty || value.length < 6) return '유효하지 않은 비밀번호입니다.';
    return null;
  }

  static String validateBio(String value) {
    if (value.isEmpty) return '소개가 입력되지 않았습니다.';
    if (value.length > 40) return '소개는 40자 이하여야 합니다.';
    return null;
  }
}
