1 contract AmIOnTheFork {
2     bool public forked = false;
3     address constant darkDAO = 0x304a554a310c7e546dfe434669c62820b7d83490;
4     // Check the fork condition during creation of the contract.
5     // This function should be called between block 1920000 and 1930000.
6     // After that the status will be locked in.
7     function update() {
8         if (block.number >= 1920000 && block.number <= 1930000) {
9             forked = darkDAO.balance < 3600000 ether;
10         }
11     }
12     function() {
13         throw;
14     }
15 }