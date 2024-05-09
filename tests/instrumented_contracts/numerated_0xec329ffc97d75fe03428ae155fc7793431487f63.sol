1 pragma solidity >=0.4.11;
2 
3 contract Owned {
4     function Owned() {
5         owner = msg.sender;
6     }
7 
8     address public owner;
9 
10     // This contract only defines a modifier and a few useful functions
11     // The function body is inserted where the special symbol "_" in the
12     // definition of a modifier appears.
13     modifier onlyOwner { if (msg.sender == owner) _; }
14 
15     function changeOwner(address _newOwner) onlyOwner {
16         owner = _newOwner;
17     }
18 
19     // This is a general safty function that allows the owner to do a lot
20     //  of things in the unlikely event that something goes wrong
21     // _dst is the contract being called making this like a 1/1 multisig
22     function execute(address _dst, uint _value, bytes _data) onlyOwner {
23         _dst.call.value(_value)(_data);
24     }
25 }
26 // to get the needed token functions in the contract
27 contract Token {
28     function transfer(address, uint) returns(bool);
29     function balanceOf(address) constant returns (uint);
30 }
31 
32 contract TokenSender is Owned {
33     Token public token; // the token we are working with
34     uint public totalToDistribute;
35 
36     uint public next;
37 
38 
39     struct Transfer {
40         address addr;
41         uint amount;
42     }
43 
44     Transfer[] public transfers;
45 
46     function TokenSender(address _token) {
47         token = Token(_token);
48     }
49 
50     // this is a used to save gas
51     uint constant D160 = 0x0010000000000000000000000000000000000000000;
52 
53     // This is the function that makes the list of transfers and various
54     //  checks around that list, it is a little tricky, the data input is
55     //  structured with the `amount` and the (receiving) `addr` combined as one
56     //  long number and then this number is deconstructed in this function to
57     //  save gas and reduce the number of `0`'s that are needed to be stored
58     //   on the blockchain
59     function fill(uint[] data) onlyOwner {
60 
61         // If the send has started then we just throw
62         if (next>0) throw;
63 
64         uint acc;
65         uint offset = transfers.length;
66         transfers.length = transfers.length + data.length;
67         for (uint i = 0; i < data.length; i++ ) {
68             address addr = address( data[i] & (D160-1) );
69             uint amount = data[i] / D160;
70 
71             transfers[offset + i].addr = addr;
72             transfers[offset + i].amount = amount;
73             acc += amount;
74         }
75         totalToDistribute += acc;
76     }
77     // This function actually makes the sends and tracks the amount of gas used
78     //  if it takes more gas than was sent with the transaction then this
79     //  function will need to be called a few times until
80     function run() onlyOwner {
81         if (transfers.length == 0) return;
82 
83         // Keep next in the stack var mNext to save gas
84         uint mNext = next;
85 
86         // Set the contract as finalized to avoid reentrance
87         next = transfers.length;
88 
89         if ((mNext == 0 ) && ( token.balanceOf(this) != totalToDistribute)) throw;
90 
91         while ((mNext<transfers.length) && ( gas() > 150000 )) {
92             uint amount = transfers[mNext].amount;
93             address addr = transfers[mNext].addr;
94             if (amount > 0) {
95                 if (!token.transfer(addr, transfers[mNext].amount)) throw;
96             }
97             mNext ++;
98         }
99 
100         // Set the next to the actual state.
101         next = mNext;
102     }
103 
104 
105     ///////////////////////
106     // Helper functions
107     ///////////////////////
108 
109     function hasTerminated() constant returns (bool) {
110         if (transfers.length == 0) return false;
111         if (next < transfers.length) return false;
112         return true;
113     }
114 
115     function nTransfers() constant returns (uint) {
116         return transfers.length;
117     }
118 
119     function gas() internal constant returns (uint _gas) {
120         assembly {
121             _gas:= gas
122         }
123     }
124 
125 }