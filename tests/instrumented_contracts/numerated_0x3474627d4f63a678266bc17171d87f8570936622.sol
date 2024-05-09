1 contract Splitter {
2     
3     bool _classic;
4     address _owner;
5     
6     function Splitter() {
7         _owner = msg.sender;
8 
9         // Balance on classic is 0.000007625764205414 (at the time of this contract)
10         if (address(0xbf4ed7b27f1d666546e30d74d50d173d20bca754).balance < 1 ether) {
11             _classic = true;
12         }
13     }
14 
15     function isClassic() constant returns (bool) {
16         return _classic;
17     }
18     
19     // Returns the ether on the real network to the sender, while forwarding
20     // the classic ether to a new address.
21     function split(address classicAddress) {
22         if (_classic){
23             if (!(classicAddress.send(msg.value))) {
24                 throw;
25             }
26         } else {
27             if (!(msg.sender.send(msg.value))) {
28                 throw;
29             }
30         }
31     }
32 
33     function claimDonations(uint balance) {
34         if (_owner != msg.sender) { return; }
35         if (!(_owner.send(balance))) {
36             throw;
37         }
38     }
39 }