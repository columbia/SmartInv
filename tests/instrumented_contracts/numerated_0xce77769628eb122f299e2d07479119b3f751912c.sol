1 pragma solidity ^0.4.11;
2 
3 
4 /*
5  * Ownable
6  *
7  * Base contract with an owner.
8  * Provides onlyOwner modifier, which prevents function from running if it is called by anyone other than the owner.
9  */
10 contract Ownable {
11   address public owner;
12 
13   function Ownable() {
14     owner = msg.sender;
15   }
16 
17   modifier onlyOwner() {
18     if (msg.sender != owner) {
19       throw;
20     }
21     _;
22   }
23 
24   function transferOwnership(address newOwner) onlyOwner {
25     if (newOwner != address(0)) {
26       owner = newOwner;
27     }
28   }
29 
30 }
31 
32 contract splitterContract is Ownable{
33 
34     event ev(string msg, address whom, uint256 val);
35 
36     struct xRec {
37         bool inList;
38         address next;
39         address prev;
40         uint256 val;
41     }
42 
43     struct l8r {
44         address whom;
45         uint256 val;
46     }
47     address public myAddress = this;
48     address public first;
49     address public last;
50     address public ddf;
51     bool    public thinkMode;
52     uint256 public pos;
53 
54     mapping (address => xRec) public theList;
55 
56     l8r[]  afterParty;
57 
58     modifier onlyMeOrDDF() {
59         if (msg.sender == ddf || msg.sender == myAddress || msg.sender == owner) {
60             _;
61             return;
62         }
63     }
64 
65     function setDDF(address ddf_) onlyOwner {
66         ddf = ddf_;
67     }
68 
69     function splitterContract(address seed, uint256 seedVal) {
70         first = seed;
71         last = seed;
72         theList[seed] = xRec(true,0x0,0x0,seedVal);
73     }
74 
75     function startThinking() onlyOwner {
76         thinkMode = true;
77         pos = 0;
78     }
79 
80     function stopThinking(uint256 num) onlyOwner {
81         thinkMode = false;
82         for (uint256 i = 0; i < num; i++) {
83             if (pos >= afterParty.length) {
84                 delete afterParty;
85                 return;
86             }
87             update(afterParty[pos].whom,afterParty[pos].val);
88             pos++;
89         }
90         thinkMode = true;
91     } 
92 
93     function thinkLength() constant returns (uint256) {
94         return afterParty.length;
95     }
96 
97     function addRec4L8R(address whom, uint256 val) internal {
98         afterParty.push(l8r(whom,val));
99     }
100 
101     function add(address whom, uint256 value) internal {
102         theList[whom] = xRec(true,0x0,last,value);
103         theList[last].next = whom;
104         last = whom;
105         ev("add",whom,value);
106     }
107 
108     function remove(address whom) internal {
109         if (first == whom) {
110             first = theList[whom].next;
111             theList[whom] = xRec(false,0x0,0x0,0);
112             return;
113         }
114         address next = theList[whom].next;
115         address prev = theList[whom].prev;
116         if (prev != 0x0) {
117             theList[prev].next = next;
118         }
119         if (next != 0x0) {
120             theList[next].prev = prev;
121         }
122         theList[whom] = xRec(false,0x0,0x0,0);
123         ev("remove",whom,0);
124     }
125 
126     function update(address whom, uint256 value) onlyMeOrDDF {
127         if (thinkMode) {
128             addRec4L8R(whom,value);
129             return;
130         }
131         if (value != 0) {
132             if (!theList[whom].inList) {
133                 add(whom,value);
134             } else {
135                 theList[whom].val = value;
136                 ev("update",whom,value);
137             }
138             return;
139         }
140         if (theList[whom].inList) {
141                 remove(whom);
142         }
143     }
144 
145 }