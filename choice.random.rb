require 'csv'
require 'rubystats'

def rand_choice(variables)
	normdist_random_sum_seoul_forest = 0
	normdist_random_sum_himr_memory = 0
	count_sample_seoul_forest = 0
	count_sample_himr_memory = 0
	
	variables.each_index do |index|
		mean = variables[index][2].to_i #평균
		direction = variables[index][1].to_i #선택방향
		#변인에서 정한 값을 평균으로 하고 분산을 10으로 하는 정규분포 생성
		norm_dist = Rubystats::NormalDistribution.new(mean , 10)
		
		#각 변인에 대해 정규분표에 의거한 랜덤 샘플 1000개씩 추출하여 합
		1000.times do
			rnd = norm_dist.rng
			#print variables[index][0], ',', mean, ',', direction, ',', rnd, "\n" 
			case direction
				when 1
				#서울숲으로 가는 정규분포 샘플 합
				normdist_random_sum_seoul_forest += rnd
				count_sample_seoul_forest += 1
				when 0
				#방향성이 없는 변인의 샘플은 양쪽에 모두 합
				normdist_random_sum_seoul_forest += rnd
				normdist_random_sum_himr_memory += rnd
				when -1
				#하이미스터메모리를 보러 가는 샘플 합
				normdist_random_sum_himr_memory += rnd
				count_sample_himr_memory += 1
			end 
		end
	end
	#puts count_sample_seoul_forest, count_sample_himr_memory
	#샘플수로 다시 나누어서(선택 방향성이 없는 샘플 갯수는무시) 샘플의 평균을 구합니다.
	seoul_forest = normdist_random_sum_seoul_forest / count_sample_seoul_forest;
	himr_memory = normdist_random_sum_himr_memory / count_sample_himr_memory;
	
	#여기에 불확실성을 추가하기 위해 각 값을 최대치로 하는 난수를 하나 골라 최종 결과로 정합니다.
	seoul_forest = rand(seoul_forest)
	himr_memory = rand(himr_memory)
	
	#0보다 크면 서울숲 go, 0보다 작으면 하이미스터메모리 go
	return seoul_forest - himr_memory
end


############ Main Routine

#변인을 읽어들임 (변인 내용은 비밀^_^)
puts "결정에 영향을 미치는 변인들을 읽어들입니다.. (변인 내용은 비밀)", "filename : variable.csv"
variables = Array.new
CSV.open('variable.csv', 'r') do |row|
    variables << row
end
puts "파일을 읽었습니다."

#100번 시도해봅니다.
puts "결정을 100번 시도하여 그 중 어느쪽이 많이 나왔는지를 봅시다.."
go_seoul_forest = go_himr_memory = none = 0
100.times do
	result = rand_choice(variables)
    go_seoul_forest += 1 if result > 0
	go_himr_memory += 1 if result < 0
	none += 1 if result == 0
end

puts "서울숲 가자! : #{go_seoul_forest} , 기억씨 보러가자! : #{go_himr_memory}, 에라 모르겠다 : #{none}"