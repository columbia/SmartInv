1 /** 
2  * @notice Smartex Controller
3  * @author Christopher Moore cmoore@smartex.io - Smartex.io Ltd. 2016 - https://smartex.io
4  */
5 
6 contract owned {
7     address public owner;
8 
9     function owned() {
10         owner = msg.sender;
11     }
12 
13     modifier onlyOwner {
14         if (msg.sender != owner) throw;
15         _;
16     }
17 
18     function transferOwnership(address newOwner) onlyOwner {
19         owner = newOwner;
20     }
21 }
22 
23 /** 
24  * @notice Smartex Invoice
25  * @author Christopher Moore cmoore@smartex.io - Smartex.io Ltd. 2016 - https://smartex.io
26  */
27 contract SmartexInvoice is owned {
28 
29     address sfm;
30 
31     /** 
32      * @notice Incoming transaction Event
33      * @notice Logs : block number, sender, value, timestamp
34      */
35     event IncomingTx(
36         uint indexed blockNumber,
37         address sender,
38         uint value,
39         uint timestamp
40     );
41 
42     /** 
43      * @notice Refund Invoice Event
44      * @notice Logs : invoice address, timestamp
45      */
46     event RefundInvoice(
47         address invoiceAddress,
48         uint timestamp
49     );
50 
51     /**
52      * @notice Invoice constructor
53      */
54     function SmartexInvoice(address target, address owner) {
55         sfm = target;
56         transferOwnership(owner);
57     }
58 
59 
60     /**
61      * @notice Refund invoice  
62      * @param recipient (address refunded)
63      */
64     function refund(address recipient) onlyOwner {
65         RefundInvoice(address(this), now);
66     }
67 
68 
69     function sweep(address _to) payable onlyOwner {
70             if (!_to.send(this.balance)) throw; 
71     }
72     
73     function advSend(address _to, uint _value, bytes _data)  onlyOwner {
74             _to.call.value(_value)(_data);
75     }
76 
77     /**
78      * @notice anonymous function
79      * @notice Triggered by invalid function calls and incoming transactions
80      */
81     function() payable {
82         IncomingTx(block.number, msg.sender, msg.value, now);
83     }
84 
85 }