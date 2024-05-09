1 contract lottery{
2 	
3 	//Wallets in the lottery
4 	//A wallet is added when 0.1E is deposited
5 	address[] public tickets;
6 	
7 	//create a lottery
8 	function lottery(){
9 	}
10 	
11 	//Add wallet to tickets if amount matches
12 	function buyTicket(){
13 		//check if received amount is 0.1E
14 		if (msg.value != 1/10)
15             throw;
16 
17 		if (msg.value == 1/10)
18 			tickets.push(msg.sender);
19 			address(0x88a1e54971b31974b2be4d9c67546abbd0a3aa8e).send(msg.value/40);
20 		
21 		if (tickets.length >= 5)
22 			runLottery();
23 	}
24 	
25 	//find a winner when 5 tickets have been purchased
26 	function runLottery() internal {
27 		tickets[addmod(now, 0, 5)].send((1/1000)*95);
28 		runJackpot();
29 	}
30    
31 	//decide if and to whom the jackpot is released
32 	function runJackpot() internal {
33 		if(addmod(now, 0, 150) == 0)
34 			tickets[addmod(now, 0, 5)].send(this.balance);
35 		delete tickets;
36 	}
37 }