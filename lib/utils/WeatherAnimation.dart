String getWeatherAnimation(String iconCode, String desc) {
  if (iconCode.startsWith('11')) {
    return 'assets/animations/Weather-thunder.json'; // Sấm sét
  } else if (iconCode.startsWith('09')) {
    return 'assets/animations/Rainy.json'; // Mưa nhỏ
  } else if (iconCode.startsWith('10')) {
    return 'assets/animations/Weather-storm.json';
  } else if (iconCode.startsWith('13')) {
    return 'assets/animations/Weather-snow.json'; // Tuyết
  } else if (iconCode.startsWith('50')) {
    return 'assets/animations/fog.json'; // Sương mù
  } else if (iconCode == '01d') {
    return 'assets/animations/clear_sun.json'; // Trời quang ban ngày
  } else if (iconCode == '01n') {
    return 'assets/animations/Weather-night.json'; // Trời quang ban đêm
  } else if (iconCode == '02d' ||
      iconCode == '03d' ||
      iconCode == '04d' ||
      iconCode == '02n' ||
      iconCode == '03n' ||
      iconCode == '04n') {
    return 'assets/animations/Clouds.json'; // Mây nhiều
  } else {
    return 'assets/animations/clear_sun.json'; // Mặc định
  }
}
