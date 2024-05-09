1 contract store {
2 
3     address owner;
4 
5     uint public contentCount = 0;
6     
7     event content(string datainfo, uint indexed version, address indexed sender, uint indexed datatype, uint timespan, uint payment);
8     modifier onlyowner { if (msg.sender == owner) _ } 
9     
10     function store() public { owner = msg.sender; }
11     
12     ///TODO: remove in release
13     function kill() onlyowner { suicide(owner); }
14 
15     function flush() onlyowner {
16         owner.send(this.balance);
17     }
18 
19     function add(string datainfo, uint version, uint datatype, uint timespan) {
20         //item listing
21         if(datatype == 1) {
22           //2 weeks listing costs 0,04 USD = 0,004 ether
23           if(timespan <= 1209600) {
24             if(msg.value < (4 finney)) return;
25           //4 weeks listing costs 0,06 USD = 0,006 ether
26           } else if(timespan <= 2419200) {
27             if(msg.value < (6 finney)) return;
28           //limit 4 weeks max
29           } else {
30             timespan = 2419200;
31             if(msg.value < (6 finney)) return;
32           }
33         }
34 
35         //revert higher payment transactions
36         if(msg.value > (6 finney)) throw;
37 
38         contentCount++;
39         content(datainfo, version, msg.sender, datatype, timespan, msg.value);
40     }
41 }