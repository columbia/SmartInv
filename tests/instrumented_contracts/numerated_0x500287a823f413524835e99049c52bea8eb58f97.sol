1 pragma solidity ^0.4.18;
2 
3 
4 
5 
6 /**
7  * @title Ownable
8  * @dev The Ownable contract has an owner address, and provides basic authorization control
9  * functions, this simplifies the implementation of "user permissions".
10  */
11 contract Ownable {
12   address public owner;
13 
14 
15   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
16 
17 
18   /**
19    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
20    * account.
21    */
22   function Ownable() public {
23     owner = msg.sender;
24   }
25 
26 
27   /**
28    * @dev Throws if called by any account other than the owner.
29    */
30   modifier onlyOwner() {
31     require(msg.sender == owner);
32     _;
33   }
34 
35 
36   /**
37    * @dev Allows the current owner to transfer control of the contract to a newOwner.
38    * @param newOwner The address to transfer ownership to.
39    */
40   function transferOwnership(address newOwner) public onlyOwner {
41     require(newOwner != address(0));
42     OwnershipTransferred(owner, newOwner);
43     owner = newOwner;
44   }
45 
46 }
47 
48 
49 
50 
51 
52 
53 contract BuckySalary is Ownable {
54 
55     string[] public staff = [ 
56         "0xE385917ACF8251fca45595b7919f38bab581749c", 
57         "0xC4Bed66d88F39C0D18cE601b408464d554A38771", 
58         "0xc07ED3e252d8C6819F763d904D1692D1242ec7ee", 
59         "0x2CD147bb1d347a6A887887B569AAa8A262cF8346", 
60         "0x6A1eBbff7714dfcE36756d09440ac979Bbf87b10", 
61         "0x729501BE221C534d9C090a8Ee4e8B5B16d6b356C", 
62         "0xad82A5fb394a525835A3a6DC34C1843e19160CFA", 
63         "0x5DD309a882c2BB49B5e5Ed1b49D209363B0f2a37", 
64         "0x490f72f8DfB81859fe61ecfe1fEB9F6C61a1aa89", 
65         "0xBd0b6cdf81B282C0401bc67d0d523D00Fc59c55c"  
66     ];
67 
68     uint[] public staffETH = [
69         1 ether,
70         1 ether,
71         1 ether,
72         1 ether,
73         1 ether,
74         1 ether,
75         1 ether,
76         1 ether,
77         0.5 ether,
78         0.5 ether
79     ];
80 
81     
82     
83     function BuckySalary() public {
84 
85     }
86 
87     function bytesToAddress (bytes b) internal constant returns (address) {
88         uint result = 0;
89         for (uint i = 0; i < b.length; i++) {
90             uint c = uint(b[i]);
91             if (c >= 48 && c <= 57) {
92                 result = result * 16 + (c - 48);
93             }
94             if(c >= 65 && c<= 90) {
95                 result = result * 16 + (c - 55);
96             }
97             if(c >= 97 && c<= 122) {
98                 result = result * 16 + (c - 87);
99             }
100         }
101         return address(result);
102     }
103       
104     
105     function strCompare(string _a, string _b) internal returns (int) {
106         bytes memory a = bytes(_a);
107         bytes memory b = bytes(_b);
108         uint minLength = a.length;
109         if (b.length < minLength) minLength = b.length;
110         for (uint i = 0; i < minLength; i ++) {
111             if (a[i] < b[i])
112                 return -1;
113             else if (a[i] > b[i])
114                 return 1;
115         }
116         if (a.length < b.length)
117             return -1;
118         else if (a.length > b.length)
119             return 1;
120         else
121             return 0;
122    } 
123 
124     function getTotal() internal view returns (uint) {
125         uint total = 0;
126         for (uint i = 0; i < staff.length; i++) {
127             total += staffETH[i];    
128         }
129 
130         return total;
131     }
132 
133     event Transfer(address a, uint v);
134 
135     function () public payable {
136         uint total = getTotal();
137         require(msg.value >= total);
138 
139         for (uint i = 0; i < staff.length; i++) {
140             bytes b = bytes(staff[i]);
141             address s = bytesToAddress(b);
142             uint value = staffETH[i];
143             if (value > 0) {
144                 s.transfer(value);
145                 Transfer(s, value);
146             }
147         }
148 
149         if (msg.value > total) {
150             msg.sender.transfer(msg.value - total);
151         }
152     }
153 
154     function addStaff(string addr, uint value) public onlyOwner {
155         for (uint i = 0; i < staff.length; i++) {
156             if (strCompare(staff[i], addr) == 0) {
157                 staffETH[i] = value;
158                 return;
159             }
160 
161             if (strCompare(staff[i], "") == 0) {
162                 staff[i] = addr;
163                 staffETH[i] = value;
164                 return;
165             }
166         }
167 
168         staff.push(addr);
169         staffETH.push(value);
170     }
171 
172     function removeStaff(string addr) public onlyOwner {
173         for (uint i = 0; i < staff.length; i++) {
174             if (strCompare(staff[i], addr) == 0) {
175                 staff[i] = "";
176                 staffETH[i] = 0;
177             }
178         }
179     }
180 
181     function setETH(string addr, uint value) public onlyOwner {
182         for (uint i = 0; i < staff.length; i++) {
183             if (strCompare(staff[i], addr) == 0) {
184                 staffETH[i] = value;
185                 return;
186             }
187         }
188     }
189 
190     
191     
192     
193     
194     
195     
196 }