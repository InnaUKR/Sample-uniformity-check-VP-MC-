class DataController < ApplicationController
  require 'Dependent criteria/dispersion'
  require 'Dependent criteria/average'
  require 'Dependent criteria/wilcoxon'
  require 'Dependent criteria/unfiformity_average'
  require 'Dependent criteria/unfiformity_wilcoxon'
  ROUND_NUMBER = 4

  def import
    Datum.import!(params[:file])
    redirect_to data_path, notice: 'File imported!'
  end

  def index
    @average_x = Datum.average(:x).to_f.round(ROUND_NUMBER)
    @average_y = Datum.average(:y).to_f.round(ROUND_NUMBER)

    @median_x = Datum.median(:x).round(ROUND_NUMBER)
    @median_y = Datum.median(:y).round(ROUND_NUMBER)

    @medium_square_x = Datum.medium_square(:x).round(ROUND_NUMBER)
    @medium_square_y = Datum.medium_square(:y).round(ROUND_NUMBER)

    @asymmetry_x = Datum.asymmetry(:x).round(ROUND_NUMBER)
    @asymmetry_y = Datum.asymmetry(:y).round(ROUND_NUMBER)

    @excess_x = Datum.excess(:x).round(ROUND_NUMBER)
    @excess_y = Datum.excess(:y).round(ROUND_NUMBER)

    @kontrekstsess_x = Datum.kontrekstsess(:x).round(ROUND_NUMBER)
    @kontrekstsess_y = Datum.kontrekstsess(:y).round(ROUND_NUMBER)

    @pirson_x = Datum.pirson(:x).round(ROUND_NUMBER)
    @pirson_y = Datum.pirson(:y).round(ROUND_NUMBER)

    #estimation
    @average_estimation_x = Datum.average_estimation(:x).round(ROUND_NUMBER)
    @average_estimation_y = Datum.average_estimation(:x).round(ROUND_NUMBER)

    @medium_square_e_estimation_x = Datum.medium_square_estimation(:x).round(ROUND_NUMBER)
    @medium_square_estimation_y = Datum.medium_square_estimation(:y).round(ROUND_NUMBER)

    @asymmetry_estimation = Datum.asymmetry_estimation.round(ROUND_NUMBER)

    @excess_estimation = Datum.excess_estimation.round(ROUND_NUMBER)

    @kontrekstsess_estimation_x = Datum.kontrekstsess_estimation(:x).round(ROUND_NUMBER)
    @kontrekstsess_estimation_y = Datum.kontrekstsess_estimation(:y).round(ROUND_NUMBER)

    @pirson_estimation_x = Datum.pirson_estimation(:x).round(ROUND_NUMBER)
    @pirson_estimation_y = Datum.pirson_estimation(:y).round(ROUND_NUMBER)

    #interval
    @average_interval_x = Datum.average_interval(:x)
    @average_interval_y = Datum.average_interval(:y)

    @medium_square_interval_x = Datum.medium_square_interval(:x)
    @medium_square_interval_y = Datum.medium_square_interval(:y)

    @asymmetry_interval_x = Datum.asymmetry_interval(:x)
    @asymmetry_interval_y = Datum.asymmetry_interval(:y)

    @excess_interval_x = Datum.excess_interval(:x)
    @excess_interval_y = Datum.excess_interval(:y)

    @kontrexcess_interval_x = Datum.kontrexcess_interval(:x)
    @kontrexcess_interval_y = Datum.kontrexcess_interval(:y)

    @pirson_interval_x = Datum.pirson_interval(:x)
    @pirson_interval_y = Datum.pirson_interval(:y)
  end

  def show_average
    @x = Datum.pluck(:x)
    @y = Datum.pluck(:y)
    average = Average.new(@x, @y)
    @z = average.z
    @avz = average.avz
    @statistic = average.statistic.round(ROUND_NUMBER)
    @student_quantile = Datum.student_quantile.round(ROUND_NUMBER)
    @subtracts = average.subtracts
    @sqrt_subtracts = average.sqrt_subtracts
    @medium_square = average.medium_square(@sqrt_subtracts).round(ROUND_NUMBER)
    @conclusion = average.conclusion
  end

  def show_dispersion
    @x = Datum.pluck(:x)
    @y = Datum.pluck(:y)
    dispersion = Dispersion.new(@x, @y)
    @avx = dispersion.av_x.round(ROUND_NUMBER)
    @avy = dispersion.av_y.round(ROUND_NUMBER)
    @statistic = dispersion.statistic.round(ROUND_NUMBER)
    @fisher_quantile = dispersion.fisher_quantile.round(ROUND_NUMBER)
    @conclusion = dispersion.conclusion
    @subtracts_x = dispersion.subtract(@x, @avx)
    @subtracts_y = dispersion.subtract(@y, @avy)
    @sqrt_subtracts_x = dispersion.sqrt_subtracts_x
    @sqrt_subtracts_y = dispersion.sqrt_subtracts_y
    @medium_square_x = dispersion.medium_square(@sqrt_subtracts_x).round(ROUND_NUMBER)
    @medium_square_y = dispersion.medium_square(@sqrt_subtracts_y).round(ROUND_NUMBER)
  end

  def show_wilcoxon
    x = Datum.pluck(:x)# [3, 9, 5, 8, 5, 6, 9, 7]
    y = Datum.pluck(:y)# [5, 4, 5, 9, 6, 10, 3, 8]
    wilcoxon = Wilcoxon.new(x, y)
    @x = wilcoxon.z.map(&:x)
    @y = wilcoxon.z.map(&:y)
    @z = wilcoxon.z.map(&:value)
    @a = wilcoxon.z.map(&:a)
    @abs_z = wilcoxon.z.map(&:abs_value)
    @rank = wilcoxon.z.map(&:rank)
    @multiple_a_rank = wilcoxon.multiple_a_rank
    @statistic = wilcoxon.statistic
    @bunch = wilcoxon.elements_number_bunch
    @dispersion = wilcoxon.dispersion
    @excess = wilcoxon.excess
    @conclusion = wilcoxon.conclusion
    @standard_statistic = wilcoxon.standard_statistic
  end

  def show_unfiformity_average
    @x = Datum.pluck(:x) # [10, 3, 18, -1, 20, 10, 3]#
    @y = Datum.pluck(:y) # [15, 7, 0, 10, 25, 9]#
    ufa = UnfiformityAverage.new
    @avx = ufa.average(@x)
    @avy = ufa.average(@y)
    @dispersion_x = ufa.dispersion(@x)
    @dispersion_y = ufa.dispersion(@y)
    @dispersion = ufa.weighted_average_dispersion(@x, @y)
    @statistic = ufa.statistic(@x, @y)
    @student_quantile = ufa.student_quantile(@x, @y)
    @conclusion = ufa.conclusion(@x, @y)

    @subtract_average_x = ufa.subtract_average(@x)
    @subtract_average_x_sqrt = ufa.subtract_average(@x, 2)

    @subtract_average_y = ufa.subtract_average(@y)
    @subtract_average_y_sqrt = ufa.subtract_average(@y, 2)
  end

  def show_unfiformity_wilcoxon
    @x = Datum.pluck(:x)#[10, 3, 18, -1, 20, 10, 3]
    @y = Datum.pluck(:y) #[15, 7, 0, 10, 25, 9]
    ufw = UnfiformityWilcoxon.new(@x, @y)
    @sample = ufw.sample
    @statistic = ufw.statistic
    @standardized_statistics = ufw.standardized_statistics
    @d = ufw.d
    @e = ufw.e
    @conclusion = ufw.conclusion
  end
end
