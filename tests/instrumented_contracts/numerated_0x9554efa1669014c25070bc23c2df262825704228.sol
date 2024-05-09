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
17 contract ReplaySafeSplit {
18     // Fork oracle to use
19     AmIOnTheFork amIOnTheFork = AmIOnTheFork(0x2bd2326c993dfaef84f696526064ff22eba5b362);
20 
21     // Splits the funds into 2 addresses
22     function split(address targetFork, address targetNoFork) returns(bool) {
23         if (amIOnTheFork.forked() && targetFork.send(msg.value)) {
24             return true;
25         } else if (!amIOnTheFork.forked() && targetNoFork.send(msg.value)) {
26             return true;
27         }
28         throw;
29     }
30 
31     // Reject value transfers.
32     function() {
33         throw;
34     }
35 }