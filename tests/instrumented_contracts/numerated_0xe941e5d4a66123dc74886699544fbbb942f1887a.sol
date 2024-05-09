1 contract SimpleCoinFlipGame {
2     event FlippedCoin(address msgSender, uint msgValue, int coinsFlipped);
3     
4     int public coinsFlipped = 422;
5     int public won = 253;
6     int public lost = 169;
7     address private owner = msg.sender;
8     // uint public lastMsgValue;
9     // uint public lastMsgGas;
10     // uint public lastRandomNumber;
11 
12     function flipTheCoinAndWin() {
13         var randomNumber = (uint(sha3(msg.gas)) + uint(coinsFlipped)) % 10;
14         
15         // lastMsgValue = msg.value;
16         // lastMsgGas = msg.gas;
17         // lastRandomNumber = randomNumber; 
18         
19         FlippedCoin(msg.sender, msg.value, coinsFlipped++);
20         
21         // wager of > 42 Finey is not accepted
22         if(msg.value > 42000000000000000){
23             msg.sender.send(msg.value - 100000);
24             won++;
25             return;   
26         }
27         
28         if(randomNumber < 4) {
29             msg.sender.send(2 * (msg.value - 100000));
30             won++;
31             return;
32         } 
33         lost++;
34     } 
35     
36     function terminate() onlyByOwner { 
37             suicide(owner); 
38     }
39     
40     modifier onlyByOwner() {
41         if (msg.sender != owner)
42             throw;
43         _
44     }
45 }