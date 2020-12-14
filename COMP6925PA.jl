using Juniper
using Ipopt
using Distributions



optimizer = Juniper.Optimizer
nl_solver = optimizer_with_attributes(Ipopt.Optimizer, "print_level"=>0)
m = Model(optimizer_with_attributes(optimizer, "nl_solver"=>nl_solver))

ItemDM = [round.(Int, rand(Normal(20, 10), 1))
        round.(Int, rand(Normal(20, 10), 1))
        round.(Int, rand(Normal(20, 10), 1))
        round.(Int, rand(Normal(20, 10), 1))
        round.(Int, rand(Normal(20, 10), 1))
        round.(Int, rand(Normal(20, 10), 1))
        round.(Int, rand(Normal(20, 10), 1))
        round.(Int, rand(Normal(20, 10), 1))]
ItemDC = [round.(Int, rand(Normal(7, 3), 1))
        round.(Int, rand(Normal(7, 3), 1))
        round.(Int, rand(Normal(7, 3), 1))
        round.(Int, rand(Normal(7, 3), 1))
        round.(Int, rand(Normal(7, 3), 1))
        round.(Int, rand(Normal(7, 3), 1))
        round.(Int, rand(Normal(7, 3), 1))
        round.(Int, rand(Normal(7, 3), 1))]
ItemDB = [round.(Int, rand(Normal(5, 2), 1))
        round.(Int, rand(Normal(5, 2), 1))
        round.(Int, rand(Normal(5, 2), 1))
        round.(Int, rand(Normal(5, 2), 1))
        round.(Int, rand(Normal(5, 2), 1))
        round.(Int, rand(Normal(5, 2), 1))
        round.(Int, rand(Normal(5, 2), 1))
        round.(Int, rand(Normal(5, 2), 1))]

ItemMCapacity = 30
ItemCCapacity = 15
ItemBCapacity = 10

RDistance = [9000.0 7300.0 13400.0 25500.0]

@variable(m, RMItems1 >= 0)
@variable(m, RMItems2 >= 0)
@variable(m, RMItems3 >= 0)
@variable(m, RMItems4 >= 0)
@constraint(m, RMItems1 <= ItemDM[1] + ItemDM[2] + ItemDM[3] ) 
@constraint(m, RMItems2 <= ItemDM[3] + ItemDM[4] ) 
@constraint(m, RMItems3 <= ItemDM[5] + ItemDM[6] ) 
@constraint(m, RMItems4 <= ItemDM[6] + ItemDM[7] + ItemDM[8] ) 
@constraint(m, RMItems1 + RMItems2 == ItemDM[1] + ItemDM[2] + ItemDM[3] + ItemDM[4] ) 
@constraint(m, RMItems3 + RMItems4 == ItemDM[5] + ItemDM[6] + ItemDM[7] + ItemDM[8] ) 

@variable(m, RCItems1 >= 0)
@variable(m, RCItems2 >= 0)
@variable(m, RCItems3 >= 0)
@variable(m, RCItems4 >= 0)
@constraint(m, RCItems1 <= ItemDC[1] + ItemDC[2] + ItemDC[3] ) 
@constraint(m, RCItems2 <= ItemDC[3] + ItemDC[4] ) 
@constraint(m, RCItems3 <= ItemDC[5] + ItemDC[6] ) 
@constraint(m, RCItems4 <= ItemDC[6] + ItemDC[7] + ItemDC[8] ) 
@constraint(m, RCItems1 + RCItems2 == ItemDC[1] + ItemDC[2] + ItemDC[3] + ItemDC[4] ) 
@constraint(m, RCItems3 + RCItems4 == ItemDC[5] + ItemDC[6] + ItemDC[7] + ItemDC[8] ) 

@variable(m, RBItems1 >= 0)
@variable(m, RBItems2 >= 0)
@variable(m, RBItems3 >= 0)
@variable(m, RBItems4 >= 0)
@constraint(m, RBItems1 <= ItemDB[1] + ItemDB[2] + ItemDB[3] ) 
@constraint(m, RBItems2 <= ItemDB[3] + ItemDB[4] ) 
@constraint(m, RBItems3 <= ItemDB[5] + ItemDB[6] ) 
@constraint(m, RBItems4 <= ItemDB[6] + ItemDB[7] + ItemDB[8] ) 
@constraint(m, RBItems1 + RBItems2 == ItemDB[1] + ItemDB[2] + ItemDB[3] + ItemDB[4] ) 
@constraint(m, RBItems3 + RBItems4 == ItemDB[5] + ItemDB[6] + ItemDB[7] + ItemDB[8] ) 



@variable(m, hM1 >= 0)
@variable(m, hM2 >= 0)
@variable(m, hM3 >= 0)
@variable(m, hM4 >= 0)
@constraint(m, RMItems1 <= ItemDM[1] + ItemDM[2] + hM1 ) 
@constraint(m, RMItems2 <= hM2 + ItemDM[4] ) 
@constraint(m, RMItems3 <= ItemDM[5] + hM3 ) 
@constraint(m, RMItems4 <= hM4 + ItemDM[7] + ItemDM[8] ) 
@constraint(m,  ItemDM[3] == hM1 + hM2  ) 
@constraint(m,  ItemDM[6] == hM3 + hM4 ) 

@variable(m, hC1 >= 0)
@variable(m, hC2 >= 0)
@variable(m, hC3 >= 0)
@variable(m, hC4 >= 0)
@constraint(m, RCItems1 <= ItemDC[1] + ItemDC[2] + hC1 ) 
@constraint(m, RCItems2 <= hC2 + ItemDC[4] ) 
@constraint(m, RCItems3 <= ItemDC[5] + hC3 ) 
@constraint(m, RCItems4 <= hC4 + ItemDC[7] + ItemDC[8] ) 
@constraint(m,  ItemDC[3] == hC1 + hC2  ) 
@constraint(m,  ItemDC[6] == hC3 + hC4 ) 

@variable(m, hB1 >= 0)
@variable(m, hB2 >= 0)
@variable(m, hB3 >= 0)
@variable(m, hB4 >= 0)
@constraint(m, RBItems1 <= ItemDB[1] + ItemDB[2] + hB1 ) 
@constraint(m, RBItems2 <= hB2 + ItemDB[4] ) 
@constraint(m, RBItems3 <= ItemDB[5] + hB3 ) 
@constraint(m, RBItems4 <= hB4 + ItemDB[7] + ItemDB[8] ) 
@constraint(m,  ItemDB[3] == hB1 + hB2  ) 
@constraint(m,  ItemDB[6] == hB3 + hB4 ) 



@variable(m,nM[1:4]>=0,Int)

@constraint(m, RMItems1 <= nM[1]*ItemCapacity)
@constraint(m, RMItems2 <= nM[2]*ItemCapacity)
@constraint(m, RMItems3 <= nM[3]*ItemCapacity)
@constraint(m, RMItems4 <= nM[4]*ItemCapacity)



@variable(m,nC[1:4]>=0,Int)

@constraint(m, RCItems1 <= nC[1]*ItemCCapacity)
@constraint(m, RCItems2 <= nC[2]*ItemCCapacity)
@constraint(m, RCItems3 <= nC[3]*ItemCCapacity)
@constraint(m, RCItems4 <= nC[4]*ItemCCapacity)



@variable(m,nB[1:4]>=0,Int)

@constraint(m, RBItems1 <= nB[1]*ItemCapacity)
@constraint(m, RBItems2 <= nB[2]*ItemCapacity)
@constraint(m, RBItems3 <= nB[3]*ItemCapacity)
@constraint(m, RBItems4 <= nB[4]*ItemCapacity)

VechicularBreakdown = [rand(NegativeBinomial(1,0.005),5)
                        rand(NegativeBinomial(1,0.005),5)
                        rand(NegativeBinomial(1,0.005),5)]

if VechicularBreakdown[1] <= 10
    NoVech1 = 1
else 
    NoVech1 = 0
end

if VechicularBreakdown[2] <= 10
    NoVech2 = 1
else 
    NoVech2 = 0
end

if VechicularBreakdown[3] <= 10
    NoVech3 = 1
else 
    NoVech3 = 0
end

DriverTurnout = [round.(Int, rand(Normal(10, 1), 1))
            round.(Int, rand(Normal(8, 2), 1))
            round.(Int, rand(Normal(8, 2), 1))]
@constraint(m, sum(nM) <= DriverTurnout[1] - NoVech1 ) 
@constraint(m, sum(nC) <= DriverTurnout[2] - NoVech2 ) 
@constraint(m, sum(nB) <= DriverTurnout[3] - NoVech3 ) 



MaxSpeed = [80 65 65]
minSpeed = [round.(Int, rand(Normal(35, 10), 1))
            round.(Int, rand(Normal(35, 10), 1))
            round.(Int, rand(Normal(35, 10), 1))]
AveSpeed = [rand((minSpeed[1], MaxSpeed[1]))
            rand((minSpeed[2], MaxSpeed[2]))
            rand((minSpeed[3], MaxSpeed[3]))]


@objective(m, Min,  (((RDistance[1]/AveSpeed[1])*nM[1]) + ((RDistance[2]/AveSpeed[1])*nM[2]) +
                    ((RDistance[3]/AveSpeed[1])*nM[3]) + ((RDistance[4]/AveSpeed[1])*nM[4])) +
                    (((RDistance[1]/AveSpeed[2])*nC[1]) + ((RDistance[2]/AveSpeed[2])*nC[2]) + 
                    ((RDistance[3]/AveSpeed[2])*nC[3]) + ((RDistance[4]/AveSpeed[2])*nC[4])) + 
                    (((RDistance[1]/AveSpeed[3])*nB[1]) + ((RDistance[2]/AveSpeed[3])*nB[2]) + 
                    ((RDistance[3]/AveSpeed[3])*nB[3]) + ((RDistance[4]/AveSpeed[3])*nB[4])))


optimize!(m)
println("n = ", value.(nM))
println("")
println("RItems1 = ", round.(Int, value.(RMItems1)))
println("RItems2 = ", round.(Int, value.(RMItems2)))
println("RItems3 = ", round.(Int, value.(RMItems3)))
println("RItems4 = ", round.(Int, value.(RMItems4)))
println("")
println("h1 = ", round.(Int, value.(hM1)))
println("h2 = ", round.(Int, value.(hM2)))
println("h3 = ", round.(Int, value.(hM3)))
println("h4 = ",round.(Int, value.(hM4)))
println("")
println("D1 = ", value.(ItemDM[1]))
println("D2 = ", value.(ItemDM[2]))
println("D3 = ", value.(ItemDM[3]))
println("D4 = ", value.(ItemDM[4]))
println("D5 = ", value.(ItemDM[5]))
println("D6 = ", value.(ItemDM[6]))
println("D7 = ", value.(ItemDM[7]))
println("D8 = ", value.(ItemDM[8]))

println("")
println("n = ", value.(nC))
println("")
println("RItems1 = ", round.(Int, value.(RCItems1)))
println("RItems2 = ", round.(Int, value.(RCItems2)))
println("RItems3 = ", round.(Int, value.(RCItems3)))
println("RItems4 = ", round.(Int, value.(RCItems4)))
println("")
println("h1 = ", round.(Int, value.(hC1)))
println("h2 = ", round.(Int, value.(hC2)))
println("h3 = ", round.(Int, value.(hC3)))
println("h4 = ",round.(Int, value.(hC4)))
println("")
println("D1 = ", value.(ItemDC[1]))
println("D2 = ", value.(ItemDC[2]))
println("D3 = ", value.(ItemDC[3]))
println("D4 = ", value.(ItemDC[4]))
println("D5 = ", value.(ItemDC[5]))
println("D6 = ", value.(ItemDC[6]))
println("D7 = ", value.(ItemDC[7]))
println("D8 = ", value.(ItemDC[8]))

println("")
println("n = ", value.(nB))
println("")
println("RItems1 = ", round.(Int, value.(RBItems1)))
println("RItems2 = ", round.(Int, value.(RBItems2)))
println("RItems3 = ", round.(Int, value.(RBItems3)))
println("RItems4 = ", round.(Int, value.(RBItems4)))
println("")
println("h1 = ", round.(Int, value.(hB1)))
println("h2 = ", round.(Int, value.(hB2)))
println("h3 = ", round.(Int, value.(hB3)))
println("h4 = ",round.(Int, value.(hB4)))
println("")
println("D1 = ", value.(ItemDB[1]))
println("D2 = ", value.(ItemDB[2]))
println("D3 = ", value.(ItemDB[3]))
println("D4 = ", value.(ItemDB[4]))
println("D5 = ", value.(ItemDB[5]))
println("D6 = ", value.(ItemDB[6]))
println("D7 = ", value.(ItemDB[7]))
println("D8 = ", value.(ItemDB[8]))




using DelimitedFiles



open("Testcsvoutput.csv", "w") do io
           #writedlm(io,  value.(nB))
           writedlm(io,  ItemDB)
       end




