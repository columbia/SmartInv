1 contract BCFSafe {
2     /* Time Deposit and Return Funds */
3     address owner;
4     uint lockTime;
5     function TimeDeposit() {
6  owner = msg.sender;
7  lockTime = now + 30 minutes;
8     }
9     function returnMyMoney(uint amount){
10         if (msg.sender==owner && now > lockTime) {
11             owner.send(amount);
12         }
13     }
14 }