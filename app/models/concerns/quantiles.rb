module Quantiles
=begin
    FIRST_KIND_ERROR = 0.05 / 2

    C0 = 2.515517
    C1 = 0.802853
    C2 = 0.010328
    D1 = 1.432788
    D2 = 0.1892659
    D3 = 0.001308
    T = Math.sqrt(-2.0 * Math.log10(FIRST_KIND_ERROR))

    def normal_distribution
      -(T - (
      (C0 + C1 * T + C2 * T**2) /
          (1.0 + D1 * T + D2 * T**2 + D3 * T**3)
      ))
    end
=end
    def fi(a=0.05)
      t = (-2.0 * Math.log(a)) ** 0.5
      c0 = 2.515517
      c1 = 0.802853
      c2 = 0.010328
      d1 = 1.432788
      d2 = 0.1892659
      d3 = 0.001308
      t - (c0 + c1 * t + c2 * t * t) / (1.0 + d1 * t + d2 * t * t + d3 * t * t * t)
    end

    def normal_quantile(p = (1 - 0.05 / 2.0))
      p > 0.5 ? fi(1.0 - p) : -fi(p)
    end


    def g1(normal_quantile)
      (normal_quantile**3 + normal_quantile)/ 4.0
    end
    def g2(normal_quantile)
      (5 * normal_quantile**5 + 16 * normal_quantile**3 + 3 * normal_quantile)/ 96.0
    end
    def g3(normal_quantile)
      (3 * normal_quantile**7 + 19 * normal_quantile**5 + 17 * normal_quantile**3 - 15 * normal_quantile)/ 384.0
    end
    def g4(normal_quantile)
      (79 * normal_quantile**9 + 779 * normal_quantile**7 + 1482 * normal_quantile**5 - 1920 * normal_quantile**3 - 945 * normal_quantile)/ 92160.0
    end
    #нормальное = 1.96

    def student_quantile(v = Datum.count - 2)
      norm_quantile = normal_quantile
      g1 = g1(norm_quantile)
      g2 = g2(norm_quantile)
      g3 = g3(norm_quantile)
      g4 = g4(norm_quantile)
      norm_quantile + (g1 / v) + (g2 / v**2) + (g3 / v**3) + (g4 / v**4)
    end

    def fisher_quantile(v1, v2)
      s = 1.0 / v1 + 1.0 / v2
      d = 1.0 / v1 - 1.0 / v2
      up = Datum.normal_quantile
      z = up * ((s / 2.0) ** 0.5) - \
        (1.0 / 6.0) * d * (up * up + 2) + \
        ((s / 2.0) ** 0.5) * \
        (
      s * (up * up + 3.0 * up) / 24.0 +
          (d * d) * (up ** 3 + 11 * up) / (72.0 * s)
      ) - \
        d * s * (up ** 3 + 9.0 * up * up + 8.0) / 120.0 + \
        d * d * d * (3.0 * (up ** 4) + 7.0 * up * up - 16.0) / (3240.0 * s) + \
        ((0.5 * s) ** 0.5) * \
        (
      s * s * (up ** 5 + 20.0 * (up ** 3) + 15 * up) / 1920.0 +
          d ** 4 * (up ** 5 + 44.0 * (up ** 3) + 183.0 * up) / 2880.0 +
          d ** 4 * (9.0 * (up ** 5) - 284.0 * (up ** 3) - 1513.0 * up) / (155520.0 * s * s)
      )
      Math.exp(2 * z)
    end

end