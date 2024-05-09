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
32 
33 contract splitterContract is Ownable{
34 
35     event ev(string msg, address whom, uint256 val);
36 
37     struct xRec {
38         bool inList;
39         address next;
40         address prev;
41         uint256 val;
42     }
43 
44     struct l8r {
45         address whom;
46         uint256 val;
47     }
48     address public myAddress = this;
49     address public first;
50     address public last;
51     address public ddf;
52     bool    public thinkMode;
53     uint256 public pos;
54 
55     mapping (address => xRec) public theList;
56 
57     l8r[]  afterParty;
58 
59     modifier onlyMeOrDDF() {
60         if (msg.sender == ddf || msg.sender == myAddress || msg.sender == owner) {
61             _;
62             return;
63         }
64     }
65 
66     function setDDF(address ddf_) onlyOwner {
67         ddf = ddf_;
68     }
69 
70     function splitterContract(address seed, uint256 seedVal) {
71         first = seed;
72         last = seed;
73         theList[seed] = xRec(true,0x0,0x0,seedVal);
74     }
75 
76     function startThinking() onlyOwner {
77         thinkMode = true;
78         pos = 0;
79     }
80 
81     function stopThinking(uint256 num) onlyOwner {
82         thinkMode = false;
83         for (uint256 i = 0; i < num; i++) {
84             if (pos >= afterParty.length) {
85                 delete afterParty;
86                 return;
87             }
88             update(afterParty[pos].whom,afterParty[pos].val);
89             pos++;
90         }
91         thinkMode = true;
92     } 
93 
94     function thinkLength() constant returns (uint256) {
95         return afterParty.length;
96     }
97 
98     function addRec4L8R(address whom, uint256 val) internal {
99         afterParty.push(l8r(whom,val));
100     }
101 
102     function add(address whom, uint256 value) internal {
103         theList[whom] = xRec(true,0x0,last,value);
104         theList[last].next = whom;
105         last = whom;
106         ev("add",whom,value);
107     }
108 
109     function remove(address whom) internal {
110         if (first == whom) {
111             first = theList[whom].next;
112             theList[whom] = xRec(false,0x0,0x0,0);
113             return;
114         }
115         address next = theList[whom].next;
116         address prev = theList[whom].prev;
117         if (prev != 0x0) {
118             theList[prev].next = next;
119         }
120         if (next != 0x0) {
121             theList[next].prev = prev;
122         }
123         theList[whom] = xRec(false,0x0,0x0,0);
124         ev("remove",whom,0);
125     }
126 
127     function update(address whom, uint256 value) onlyMeOrDDF {
128         if (thinkMode) {
129             addRec4L8R(whom,value);
130             return;
131         }
132         if (value != 0) {
133             if (!theList[whom].inList) {
134                 add(whom,value);
135             } else {
136                 theList[whom].val = value;
137                 ev("update",whom,value);
138             }
139             return;
140         }
141         if (theList[whom].inList) {
142                 remove(whom);
143         }
144     }
145 
146 }