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