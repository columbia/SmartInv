1 /* A contract to store a state of goods (single item). Buy orders obtainable as events. */
2 
3 /* Deployment:
4 */
5 
6 contract goods {
7 
8     address public owner;
9     //status of the goods: Available, Pending, Sold, Canceled
10     uint16 public status;
11     //how many for sale
12     uint16 public count;
13     //price per item
14     uint public price;
15 
16     uint16 public availableCount;
17     uint16 public pendingCount;
18 
19     event log_event(string message);
20     event content(string datainfo, uint indexed version, uint indexed datatype, address indexed sender, uint count, uint payment);
21     modifier onlyowner { if (msg.sender == owner) _ } 
22     
23     function goods(uint16 _count, uint _price) {
24         owner = msg.sender;
25         //status = Available
26         status = 1;
27         count = _count;
28         price = _price;
29 
30         availableCount = count;
31         pendingCount = 0;
32     }
33     
34     function kill() onlyowner { suicide(owner); }
35 
36     function flush() onlyowner {
37         owner.send(this.balance);
38     }
39 
40     function log(string message) private {
41         log_event(message);
42     }
43 
44     function buy(string datainfo, uint _version, uint16 _count) {
45         if(status != 1) { log("status != 1"); throw; }
46         if(msg.value < (price * _count)) { log("msg.value < (price * _count)"); throw; }
47         if(_count > availableCount) { log("_count > availableCount"); throw; }
48 
49         pendingCount += _count;
50 
51         //Buy order to event log
52         content(datainfo, _version, 1, msg.sender, _count, msg.value);
53     }
54 
55     function accept(string datainfo, uint _version, uint16 _count) onlyowner {
56         if(_count > availableCount) { log("_count > availableCount"); return; }
57         if(_count > pendingCount) { log("_count > pendingCount"); return; }
58         
59         pendingCount -= _count;
60         availableCount -= _count;
61 
62         //Accept order to event log
63         content(datainfo, _version, 2, msg.sender, _count, 0);
64     }
65 
66     function reject(string datainfo, uint _version, uint16 _count, address recipient, uint amount) onlyowner {
67         if(_count > pendingCount) { log("_count > pendingCount"); return; }
68 
69         pendingCount -= _count;
70         //send money back
71         recipient.send(amount);
72 
73         //Reject order to event log
74         content(datainfo, _version, 3, msg.sender, _count, amount);
75     }
76 
77     function cancel(string datainfo, uint _version) onlyowner {
78         //Canceled status
79         status = 2;
80 
81         //Cancel order to event log
82         content(datainfo, _version, 4, msg.sender, availableCount, 0);
83     }
84 }