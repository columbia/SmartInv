1 contract Lottery
2 {
3     struct Ticket
4     {
5         uint pickYourLuckyNumber;
6         uint deposit;
7     }
8 	
9 	uint		limit = 6;
10 	uint 		count = 0;
11 	address[] 	senders;
12 	uint 		secretSum;
13 	uint[] 		secrets;
14 
15     mapping(address => Ticket[]) tickets;
16 
17     //buy a ticket and send a hidden integer
18 	//that will take part in determining the 
19 	//final winner.
20     function buyTicket(uint _blindRandom)
21     {
22 		uint de = 100000000000000000;
23 		//incorrect submission amout. Return
24 		//everything but 0.1E fee
25 		if(msg.value != 1000000000000000000){
26 			if(msg.value > de)
27 			msg.sender.send(msg.value-de);
28 		}
29 		//buy ticket
30 		if(msg.value == 1000000000000000000){
31 	        tickets[msg.sender].push(Ticket({
32 	            pickYourLuckyNumber: _blindRandom,
33 	            deposit: msg.value
34 	        }));
35 			count += 1;
36 			senders.push(msg.sender);
37 		}
38 		//run lottery when 'limit' tickets are bought
39 		if(count >= limit){
40 			for(uint i = 0; i < limit; ++i){
41 				var tic = tickets[senders[i]][0];
42 				secrets.push(tic.pickYourLuckyNumber);
43 			}
44 			//delete secret tickets
45 			for(i = 0; i < limit; ++i){
46 				delete tickets[senders[i]];
47 			}
48 			//find winner
49 			secretSum = 0;
50 			for(i = 0; i < limit; ++i){
51 				secretSum = secretSum + secrets[i];
52 			}
53 			//send winnings to winner				
54 			senders[addmod(secretSum,0,limit)].send(5000000000000000000);
55 			//send 2.5% to house
56 			address(0x2179987247abA70DC8A5bb0FEaFd4ef4B8F83797).send(200000000000000000);
57 			//Release jackpot?
58 			if(addmod(secretSum+now,0,50) == 7){
59 				senders[addmod(secretSum,0,limit)].send(this.balance - 1000000000000000000);
60 			}
61 			count = 0; secretSum = 0; delete secrets; delete senders;
62 		}
63     }
64 }