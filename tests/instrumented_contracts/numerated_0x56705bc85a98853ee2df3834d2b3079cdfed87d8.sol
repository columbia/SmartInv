1 contract ConsultingHalf {
2     /*
3      *  This contract accepts payment from clients, and payout to engineer and manager.
4      */
5     address public engineer;
6     address public manager;
7     uint public createdTime;
8     uint public updatedTime;
9 
10     function ConsultingHalf(address _engineer, address _manager) {
11         engineer = _engineer;
12         manager = _manager;
13         createdTime = block.timestamp;
14         updatedTime = block.timestamp;
15     }
16 
17     /* Contract payout hald */
18     function payout() returns (bool _success) {
19         if(msg.sender == engineer || msg.sender == manager) {
20              engineer.send(this.balance / 2);
21              manager.send(this.balance);
22              updatedTime = block.timestamp;
23              _success = true;
24         }else{
25             _success = false;
26         }
27     }
28 }