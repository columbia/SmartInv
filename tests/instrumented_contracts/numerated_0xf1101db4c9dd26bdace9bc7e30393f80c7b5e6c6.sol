1 contract AmIOnTheFork {
2     bool public forked = false;
3     address constant darkDAO = 0x304a554a310c7e546dfe434669c62820b7d83490;
4     // Check the fork condition during creation of the contract.
5     // This function should be called between block 1920000 and 1921200.
6     // Approximately between 2016-07-20 12:00:00 UTC and 2016-07-20 17:00:00 UTC.
7     // After that the status will be locked in.
8     function update() {
9         if (block.number >= 1920000 && block.number <= 1921200) {
10             forked = darkDAO.balance < 3600000 ether;
11         }
12     }
13     function() {
14         throw;
15     }
16 }
17 
18 contract MyReplaySafeProxy {
19     
20     address eth_target = 0x447F7556C8D2E5281438358087DdD368B6bCb824; 
21     address ethc_target = 0xCd76f273d307551016452724241EA3C1775270a2;
22 
23 	address public target;
24 	
25     AmIOnTheFork amIOnTheFork = AmIOnTheFork(0x2bd2326c993dfaef84f696526064ff22eba5b362);
26     
27     function MyReplaySafeProxy () {
28 			if (amIOnTheFork.forked())
29 				target =  eth_target;
30 			else
31 				target =  ethc_target;
32     }
33 
34     function() {
35         if(!target.send(msg.value))
36             throw;
37     }
38 }