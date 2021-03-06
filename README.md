# asm-5term
Требуется написать 2 функции: выполняющие прямое и обратное быстрое преобразование Фурье (FFT) размером 8x8.

Прототипы функций:

`void fFFT(const float *in, float *out);`

`void iFFT(const float *in, float *out);`

`in`  - указатель на входные данные,
`out` - указатель на выходные данные.
Входные и выходные данные - массивы комплексных чисел, лежащих как `float` действительная часть и `float` мнимая часть подряд. То есть массивы эффективно выглядят как `float data[8][8][2];`

Можно писать как 32-битный, так и 64-битный код.
32-битный код: конвенция вызова **cdecl**, к именам нужно добавлять символ `_` , то есть называться они у вас будут `_fFFT` и `_iFFT`.

64-битный код: конвенция вызова **fastcall64**, к именам не нужно добавлять символ `_` , то есть называться они у вас будут `fFFT` и `iFFT`.

Обе функции должны быть реализованы в одном .asm файле и не использовать каких-либо внешних функций.
Из **SIMD** расширений разрешается использовать всё вплоть до **AVX2** включительно.

Входные и выходные данные в памяти не пересекаются и их начала выравнены на границу, кратную 32.

Оцениваться будет как правильность реализации, так и скорость работы.

Функции будут вызываться много раз, так что, если вам требуется какая-то начальная инициализация, позаботьтесь, чтобы она не повторялась при каждом вызове.

Пример входных данных для `fFFT`:

 -1634.2   +208.4i,  -1004.9  +1011.7i,    278.6    -65.9i,   -490.5  +1297.5i,   1057.9   +808.1i,  -1067.8  +1176.2i,    689.8    +44.4i,   -642.2  -1589.2i,
 -1338.8   -444.1i,  -1155.6  -1094.7i,   1600.8   -177.9i,  -1248.1  -1623.0i,  -1609.1   -400.1i,    103.8   +233.3i,    333.5   +351.2i,  -1093.6   +534.3i,
  -161.2   -484.5i,  -1451.4   +352.9i,    928.4   +991.6i,     65.2   -648.9i,   1232.0   +742.8i,   1493.9  +1395.0i,    129.0  -1171.9i,   -124.2   -867.2i,
  1187.0   -951.5i,    916.4  +1126.1i,   1627.9  +1637.4i,    365.4   -352.4i,   -766.0   -664.2i,   1114.6  -1560.5i,   -406.7  -1334.8i,    580.7  -1454.1i,
 -1609.5  +1372.3i,   -734.3   -744.1i,    288.1   +626.5i,   1106.3   +742.2i,    -49.3   -965.4i,    798.7   -103.3i,   -137.7  +1471.8i,    801.0  -1283.5i,
   324.6   -376.0i,    770.1   +357.1i,    237.3   -454.3i,  -1141.7   -900.7i,   -245.2   +992.5i,     56.1  +1605.6i,    824.3   -506.0i,  -1084.6   +515.5i,
   -26.5  -1430.1i,    654.6    +15.8i,  -1155.0  +1473.2i,  -1174.4  +1327.5i,    632.1   -645.3i,   -240.6  -1407.7i,   1529.0   +600.3i,  -1136.2  +1236.2i,
  1054.1   +268.9i,  -1011.3  -1055.4i,   1039.4    -81.0i,  -1128.6    +12.9i,    760.3   -309.3i,   -722.2   +225.3i,    597.2   +838.4i,    727.2    -80.9i

Пример выходных данных для `fFFT`:

   113.9   +365.0i,   -712.8  -1417.9i,  -4928.6 -10658.9i,  -3954.5  +7433.3i,  14310.3  +3566.0i,   1590.8  -3947.7i, -14262.8  -2382.1i,  -9792.3  -7650.5i,
-14516.2   -997.3i,  -9159.6   -969.5i,   2096.5   +178.0i,   5434.2  -1346.7i,  14654.4  +3693.2i, -12806.2  -8221.6i,  -1778.4 +10531.4i,   5992.2  +4075.1i,
 -1196.9 +13129.6i,  -4207.5  +8611.8i,  -2048.0 +11942.7i,  -1316.7 +12825.5i,  -8088.5  +3650.2i,  -7991.3  +2963.8i,   1401.0  +4655.1i,  -2100.1  -3773.9i,
 -2258.4  +5741.4i,  12466.4 -13149.1i,  -2175.1 +10354.3i,  -7509.0 -12518.7i,   3055.0  -3268.0i,   -538.7   +728.5i,  -7592.1  +3650.9i,   -338.0   +211.3i,
 -2424.5 +10609.8i,  -6786.7   +743.3i,   1674.6  +1845.1i,   -191.3   +381.2i,  -4033.7   -235.6i, -10984.5 +11005.9i,   5081.2  -6258.9i, -19601.5  -8740.4i,
  6242.8  -1510.7i,   6322.4  +2133.4i,  18425.1 -10527.8i,   5106.8  -6093.3i,   1540.6 -11820.4i,  -1647.8  -3567.9i,    664.8 +11608.8i, -11837.2  -3631.9i,
 -5892.5  -8073.6i,  -2958.6 -14350.3i,    580.4  +5389.1i,   9343.1  +5408.0i,  -1718.5  +4990.2i,  -9612.6 +10178.3i, -14329.0  -9759.3i,   1239.7  +8137.6i,
 -2574.6  +3865.4i,  -2485.9  -1583.9i,  -6145.7  +7301.5i, -11665.4  +1869.7i,   9060.4  -7785.2i,   4674.2  +7826.9i,  -1379.1 -11261.9i,   -118.8 -12760.7i

Функция `iFFT` выполняет обратное преобразование и по второму массиву должна получить первый, умноженный на 64, не считая некоторой погрешности вычислений.
