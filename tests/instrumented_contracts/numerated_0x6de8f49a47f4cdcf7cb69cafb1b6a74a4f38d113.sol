1 // IMAERO.IO
2 
3 // My name is Alexander Kosachev, I AM AERO Founder. 
4 // I would like to present you I AM AERO project - real company from real economy sector. 
5 // We have more than 15-years history of creation of aviation equipment and helicopters. 
6 // Company with great potential for development in real time.
7 
8 // By this link you'll find more information about I AM AERO 
9 // https://www.youtube.com/watch?v=7NJS4UFVMDQ
10 
11 // For more information, please visit our website: www.iamaero.io
12 // Token sale is in process at the moment. Take a chance!
13 
14 // Telegram: @Kosachev_as
15 // Best regards,
16 // Alexander Kosachev, 
17 // Founder&CEO I AM AERO
18 // Facebook www.facebook.com/kosachev.as
19 // Telegram: @Kosachev_as
20 
21 
22 contract ERC20 {
23     function balanceOf(address who) public view returns(uint256);
24     function transfer(address to, uint256 value) public returns(bool);
25 }
26 
27 contract TokenDrop {
28     ERC20 token;
29 
30     function TokenDrop() {
31         token = ERC20(0x93D3F120D5d594E764Aa3a0Ac0AfCBAD07944f71);
32     }
33 
34     function multiTransfer(uint256 _value, address[] _to) public returns(bool) {
35         for(uint i = 0; i < _to.length; i++) {
36             token.transfer(_to[i], _value);
37         }
38 
39         return true;
40     }
41     
42     function balanceOf(address who) public view returns(uint256) {
43         return token.balanceOf(who);
44     }
45 }