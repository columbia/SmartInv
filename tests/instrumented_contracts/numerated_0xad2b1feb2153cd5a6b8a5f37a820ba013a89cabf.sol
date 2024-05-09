1 pragma solidity 0.4.4;
2 
3 contract Reward{
4     
5     function reward(uint32[] rewardsDistribution, address[] winners) payable{
6         
7         if(rewardsDistribution.length == 0 || rewardsDistribution.length > 64){ // do not risk gas shortage on reward
8 			throw;
9 		}
10 		//ensure rewardsDistribution give always something and do not give more to a lower scoring player
11 		uint32 prev = 0;
12 		for(uint8 i = 0; i < rewardsDistribution.length; i++){
13 			if(rewardsDistribution[i] == 0 ||  (prev != 0 && rewardsDistribution[i] > prev)){
14 				throw;
15 			}
16 			prev = rewardsDistribution[i];
17 		}
18 		
19         uint8 numWinners = uint8(rewardsDistribution.length);
20 
21 		if(numWinners > uint8(winners.length)){
22 			numWinners = uint8(winners.length);
23 		}
24 		
25         uint forJack = msg.value;
26 		uint64 total = 0;
27 		for(uint8 j=0; j<numWinners; j++){ // distribute all the winning even if there is not enought winners
28 			total += rewardsDistribution[j];
29 		}
30 		for(uint8 k=0; k<numWinners; k++){
31 			uint value = (msg.value * rewardsDistribution[k]) / total;
32 			if(winners[k].send(value)){ // skip winner if fail to send but still use next distribution index
33 				forJack = forJack - value;
34 			}
35 		}
36 		
37 		if(forJack > 0){
38 		    if(!msg.sender.send(forJack)){
39 		        throw;
40 		    } 
41 		}
42 		
43     }
44     
45 }