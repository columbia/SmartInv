1 pragma solidity ^0.4.18;
2 
3 contract BBTDonate {
4 
5     address public owner;
6     bool public isClosed;
7     uint256 public totalReceive;
8     uint256 public remain;
9     mapping (address => uint256) public record;
10     mapping (address => bool) public isAdmin;
11 
12     modifier onlyAdmin {
13         require(msg.sender == owner || isAdmin[msg.sender]);
14         _;
15     }
16     
17     modifier onlyOwner {
18         require(msg.sender == owner);
19         _;
20     }
21     
22     function BBTDonate() public {
23         owner = msg.sender;
24         totalReceive = 0;
25         isClosed = false;
26     }
27     
28     function () payable public {
29         record[msg.sender] = add(record[msg.sender], msg.value);
30         totalReceive = add(totalReceive, msg.value);
31     }
32     
33     function refund(address thankyouverymuch) public {
34         require(isClosed);
35         require(record[thankyouverymuch] != 0);
36         uint256 amount = div(mul(remain, record[thankyouverymuch]), totalReceive);
37         record[thankyouverymuch] = 0;
38         require(thankyouverymuch.send(amount));
39     }
40     
41     // only admin
42     function dispatch (address _receiver, uint256 _amount, string log) onlyAdmin public {
43         require(bytes(log).length != 0);
44         require(_receiver.send(_amount));
45     }
46     
47 
48     // only owner
49     function changeOwner (address _owner) onlyOwner public {
50         owner = _owner;
51     }
52     
53     function addAdmin (address _admin, bool remove) onlyOwner public {
54         if(remove) {
55             isAdmin[_admin] = false;
56         }
57         isAdmin[_admin] = true;
58     }
59     
60     function turnOff () onlyOwner public {
61         isClosed = true;
62         remain = this.balance;
63     }
64     
65     function collectBalance () onlyOwner public {
66         require(isClosed);
67         require(owner.send(this.balance));
68     }
69     
70     // helper function
71     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
72         uint256 c = a * b;
73         assert(a == 0 || c / a == b);
74         return c;
75     }
76 
77     function div(uint256 a, uint256 b) internal pure returns (uint256) {
78         // assert(b > 0); // Solidity automatically throws when dividing by 0
79         uint256 c = a / b;
80         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
81         return c;
82     }
83     
84     function add(uint256 a, uint256 b) internal pure returns (uint256) {
85         uint256 c = a + b;
86         assert(c >= a);
87         return c;
88     } 
89     
90 
91 }