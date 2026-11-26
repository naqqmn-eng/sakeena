import '../models/dhikr.dart';

/// الأذكار المدمجة مع التطبيق.
///
/// الأذكار المدمجة ثابتة ولا يمكن للمستخدم تعديلها أو حذفها؛ يمكنه فقط
/// إضافة أذكاره الخاصة. المعرّفات هنا ثابتة لأنها تُحفظ في التخزين المحلي.
class AdhkarSeed {
  const AdhkarSeed._();

  static const List<Dhikr> builtIn = <Dhikr>[
    Dhikr(
      id: 'builtin_tasbeeh',
      text: 'سُبْحَانَ اللَّه',
      description: 'تسبيح — تُقال في كل وقت، ومن قالها مئة مرة حُطَّت خطاياه.',
      actionLabel: 'تسبيح',
      isBuiltIn: true,
    ),
    Dhikr(
      id: 'builtin_tahmeed',
      text: 'الْحَمْدُ لِلَّه',
      description: 'حمد الله على كل حال.',
      actionLabel: 'تحميد',
      isBuiltIn: true,
    ),
    Dhikr(
      id: 'builtin_takbeer',
      text: 'اللَّهُ أَكْبَر',
      description: 'تكبير الله وتعظيمه.',
      actionLabel: 'تكبير',
      isBuiltIn: true,
    ),
    Dhikr(
      id: 'builtin_tahlil',
      text: 'لَا إِلَهَ إِلَّا اللَّه',
      description: 'كلمة التوحيد، أفضل ما قاله النبيون.',
      actionLabel: 'تهليل',
      isBuiltIn: true,
    ),
    Dhikr(
      id: 'builtin_tahlil_full',
      text:
          'لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ '
          'وَلَهُ الْحَمْدُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِير',
      description:
          'من قالها مئة مرة في يوم كانت له عدل عشر رقاب، وكُتبت له مئة حسنة.',
      actionLabel: 'لا إله إلا الله',
      isBuiltIn: true,
    ),
    Dhikr(
      id: 'builtin_subhan_allah_wa_bihamdih',
      text: 'سُبْحَانَ اللَّهِ وَبِحَمْدِه',
      description:
          'من قالها مئة مرة في يوم حُطَّت خطاياه وإن كانت مثل زبد البحر.',
      actionLabel: 'سبحان الله وبحمده',
      isBuiltIn: true,
    ),
    Dhikr(
      id: 'builtin_subhan_allah_azim',
      text: 'سُبْحَانَ اللَّهِ وَبِحَمْدِهِ، سُبْحَانَ اللَّهِ الْعَظِيم',
      description: 'كلمتان خفيفتان على اللسان، ثقيلتان في الميزان.',
      actionLabel: 'سبحان الله العظيم',
      isBuiltIn: true,
    ),
    Dhikr(
      id: 'builtin_istighfar',
      text: 'أَسْتَغْفِرُ اللَّه',
      description: 'طلب المغفرة من الله.',
      actionLabel: 'استغفار',
      isBuiltIn: true,
    ),
    Dhikr(
      id: 'builtin_istighfar_taubah',
      text: 'أَسْتَغْفِرُ اللَّهَ وَأَتُوبُ إِلَيْه',
      description:
          'كان النبي ﷺ يستغفر الله ويتوب إليه في اليوم أكثر من سبعين مرة.',
      actionLabel: 'استغفار وتوبة',
      isBuiltIn: true,
    ),
    Dhikr(
      id: 'builtin_hawqala',
      text: 'لَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللَّه',
      description: 'كنز من كنوز الجنة، واستسلام لله في كل أمر.',
      actionLabel: 'حوقلة',
      isBuiltIn: true,
    ),
    Dhikr(
      id: 'builtin_baghiyat',
      text:
          'سُبْحَانَ اللَّهِ وَالْحَمْدُ لِلَّهِ وَلَا إِلَهَ إِلَّا اللَّهُ '
          'وَاللَّهُ أَكْبَر',
      description: 'الباقيات الصالحات، أحب الكلام إلى الله.',
      actionLabel: 'الباقيات الصالحات',
      isBuiltIn: true,
    ),
    Dhikr(
      id: 'builtin_yunus',
      text: 'لَا إِلَهَ إِلَّا أَنْتَ سُبْحَانَكَ إِنِّي كُنْتُ مِنَ الظَّالِمِين',
      description: 'دعوة ذي النون، ما دعا بها مكروب إلا فرّج الله عنه.',
      actionLabel: 'دعوة ذي النون',
      isBuiltIn: true,
    ),
    Dhikr(
      id: 'builtin_salawat',
      text: 'اللَّهُمَّ صَلِّ وَسَلِّمْ عَلَى نَبِيِّنَا مُحَمَّد',
      description:
          'من صلى عليّ صلاة صلى الله عليه بها عشراً.',
      actionLabel: 'صلاة على النبي',
      isBuiltIn: true,
    ),
    Dhikr(
      id: 'builtin_salawat_ibrahimi',
      text:
          'اللَّهُمَّ صَلِّ عَلَى مُحَمَّدٍ وَعَلَى آلِ مُحَمَّدٍ، كَمَا '
          'صَلَّيْتَ عَلَى إِبْرَاهِيمَ وَعَلَى آلِ إِبْرَاهِيمَ، إِنَّكَ '
          'حَمِيدٌ مَجِيد',
      description: 'الصلاة الإبراهيمية التي تُقال في التشهد.',
      actionLabel: 'الصلاة الإبراهيمية',
      isBuiltIn: true,
    ),
    Dhikr(
      id: 'builtin_hasbi',
      text: 'حَسْبِيَ اللَّهُ وَنِعْمَ الْوَكِيل',
      description: 'تفويض الأمر إلى الله والاعتماد عليه.',
      actionLabel: 'حسبي الله',
      isBuiltIn: true,
    ),
    Dhikr(
      id: 'builtin_bismillah_protection',
      text:
          'بِسْمِ اللَّهِ الَّذِي لَا يَضُرُّ مَعَ اسْمِهِ شَيْءٌ فِي الْأَرْضِ '
          'وَلَا فِي السَّمَاءِ وَهُوَ السَّمِيعُ الْعَلِيم',
      description:
          'من قالها ثلاثاً حين يصبح وثلاثاً حين يمسي لم يضره شيء.',
      actionLabel: 'بسم الله الذي لا يضر',
      isBuiltIn: true,
    ),
    Dhikr(
      id: 'builtin_raditu',
      text:
          'رَضِيتُ بِاللَّهِ رَبًّا، وَبِالْإِسْلَامِ دِينًا، وَبِمُحَمَّدٍ ﷺ '
          'نَبِيًّا',
      description: 'من قالها ثلاثاً وجبت له الجنة.',
      actionLabel: 'رضيت بالله ربا',
      isBuiltIn: true,
    ),
    Dhikr(
      id: 'builtin_sayyid_istighfar',
      text:
          'اللَّهُمَّ أَنْتَ رَبِّي لَا إِلَهَ إِلَّا أَنْتَ، خَلَقْتَنِي وَأَنَا '
          'عَبْدُكَ، وَأَنَا عَلَى عَهْدِكَ وَوَعْدِكَ مَا اسْتَطَعْتُ، أَعُوذُ '
          'بِكَ مِنْ شَرِّ مَا صَنَعْتُ، أَبُوءُ لَكَ بِنِعْمَتِكَ عَلَيَّ، '
          'وَأَبُوءُ بِذَنْبِي فَاغْفِرْ لِي، فَإِنَّهُ لَا يَغْفِرُ الذُّنُوبَ '
          'إِلَّا أَنْتَ',
      description:
          'سيد الاستغفار: من قالها موقناً بها حين يصبح فمات من يومه دخل الجنة.',
      actionLabel: 'سيد الاستغفار',
      isBuiltIn: true,
    ),
    Dhikr(
      id: 'builtin_morning',
      text:
          'أَصْبَحْنَا وَأَصْبَحَ الْمُلْكُ لِلَّهِ، وَالْحَمْدُ لِلَّهِ، لَا '
          'شَرِيكَ لَهُ',
      description: 'من أذكار الصباح، تُقال بعد الفجر.',
      actionLabel: 'أذكار الصباح',
      isBuiltIn: true,
    ),
    Dhikr(
      id: 'builtin_evening',
      text:
          'أَمْسَيْنَا وَأَمْسَى الْمُلْكُ لِلَّهِ، وَالْحَمْدُ لِلَّهِ، لَا '
          'شَرِيكَ لَهُ',
      description: 'من أذكار المساء، تُقال بعد العصر.',
      actionLabel: 'أذكار المساء',
      isBuiltIn: true,
    ),
    Dhikr(
      id: 'builtin_afiyah',
      text:
          'اللَّهُمَّ إِنِّي أَسْأَلُكَ الْعَفْوَ وَالْعَافِيَةَ فِي الدُّنْيَا '
          'وَالْآخِرَة',
      description: 'من جوامع الدعاء، سأله النبي ﷺ لأمته.',
      actionLabel: 'العفو والعافية',
      isBuiltIn: true,
    ),
    Dhikr(
      id: 'builtin_hamm_hazan',
      text:
          'اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنَ الْهَمِّ وَالْحَزَنِ، وَالْعَجْزِ '
          'وَالْكَسَلِ، وَالْبُخْلِ وَالْجُبْنِ، وَضَلَعِ الدَّيْنِ وَغَلَبَةِ '
          'الرِّجَال',
      description: 'تعوّذ منها النبي ﷺ، وهي من أذكار الصباح والمساء.',
      actionLabel: 'دعاء الهم والحزن',
      isBuiltIn: true,
    ),
    Dhikr(
      id: 'builtin_hayy_qayyum',
      text:
          'يَا حَيُّ يَا قَيُّومُ بِرَحْمَتِكَ أَسْتَغِيثُ، أَصْلِحْ لِي شَأْنِي '
          'كُلَّهُ، وَلَا تَكِلْنِي إِلَى نَفْسِي',
      description: 'دعاء الكرب والاشتغال بالله.',
      actionLabel: 'يا حي يا قيوم',
      isBuiltIn: true,
    ),
    Dhikr(
      id: 'builtin_after_prayer_subhan',
      text: 'سُبْحَانَ اللَّه',
      description: 'تسبيح بعد الصلاة ثلاثاً وثلاثين مرة.',
      actionLabel: 'تسبيح بعد الصلاة',
      isBuiltIn: true,
    ),
    Dhikr(
      id: 'builtin_after_prayer_hamd',
      text: 'الْحَمْدُ لِلَّه',
      description: 'حمد بعد الصلاة ثلاثاً وثلاثين مرة.',
      actionLabel: 'حمد بعد الصلاة',
      isBuiltIn: true,
    ),
    Dhikr(
      id: 'builtin_after_prayer_akbar',
      text: 'اللَّهُ أَكْبَر',
      description: 'تكبير بعد الصلاة أربعاً وثلاثين مرة.',
      actionLabel: 'تكبير بعد الصلاة',
      isBuiltIn: true,
    ),
    Dhikr(
      id: 'builtin_sleep',
      text: 'بِاسْمِكَ اللَّهُمَّ أَمُوتُ وَأَحْيَا',
      description: 'ذكر النوم، يُقال عند الاستلقاء.',
      actionLabel: 'ذكر النوم',
      isBuiltIn: true,
    ),
    Dhikr(
      id: 'builtin_wake',
      text: 'الْحَمْدُ لِلَّهِ الَّذِي أَحْيَانَا بَعْدَ مَا أَمَاتَنَا وَإِلَيْهِ النُّشُور',
      description: 'ذكر الاستيقاظ من النوم.',
      actionLabel: 'ذكر الاستيقاظ',
      isBuiltIn: true,
    ),
    Dhikr(
      id: 'builtin_count_creatures',
      text:
          'سُبْحَانَ اللَّهِ عَدَدَ خَلْقِهِ، سُبْحَانَ اللَّهِ رِضَا نَفْسِهِ، '
          'سُبْحَانَ اللَّهِ زِنَةَ عَرْشِهِ، سُبْحَانَ اللَّهِ مِدَادَ '
          'كَلِمَاتِه',
      description:
          'تُقال حين يُسأل الإنسان كيف يسبح، وهي من أذكار الصباح والمساء.',
      actionLabel: 'سبحان الله عدد خلقه',
      isBuiltIn: true,
    ),
    Dhikr(
      id: 'builtin_la_ilaha_ant',
      text: 'اللَّهُمَّ اغْفِرْ لِي ذَنْبِي كُلَّهُ، دِقَّهُ وَجِلَّهُ، وَأَوَّلَهُ وَآخِرَهُ',
      description: 'دعاء جامع لمغفرة الذنوب كلها.',
      actionLabel: 'اللهم اغفر لي ذنبي',
      isBuiltIn: true,
    ),
  ];
}
