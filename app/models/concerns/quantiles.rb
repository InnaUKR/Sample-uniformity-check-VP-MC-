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

    def normal_distribution(p = (1 -0.05 / 2.0))
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

    def student_distribution
      normal_quantile = normal_distribution
      g1 = g1(normal_quantile)
      g2 = g2(normal_quantile)
      g3 = g3(normal_quantile)
      g4 = g4(normal_quantile)
      v = Datum.count - 2
      normal_quantile + (g1 / v) + (g2 / v**2) + (g3 / v**3) + (g4 / v**4)
    end

end