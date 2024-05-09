1 pragma solidity ^0.4.18;
2 
3 contract RandomContract {
4     
5   uint64 _seed = 0;
6   address public admin;
7   
8   event LogRandom(uint64 _randomNumber);
9   
10   function RandomContract () public {
11       admin = msg.sender;
12   }
13   
14   modifier ifAdmin() {
15       if(admin != msg.sender){
16           revert();
17       }else{
18           _;
19       }
20   }
21   
22   function doRandom(uint64 upper) public ifAdmin returns(uint64 randomNumber) {
23     _seed = uint64(keccak256(keccak256(block.blockhash(block.number), _seed), now ));
24     uint64 _randomNumber = _seed % upper;
25     LogRandom(_randomNumber);
26     return _randomNumber;
27   }
28 }