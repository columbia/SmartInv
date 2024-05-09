1 pragma solidity ^0.5.0;
2 
3 contract Access{
4     mapping(address => bool) winners;
5     
6     address public owner;
7     address public signer;
8     bool paused;
9     
10     bytes32 constant public PAUSED = keccak256(abi.encodePacked("Pause"));
11     bytes32 constant public UNPAUSED = keccak256(abi.encodePacked("Unpause"));
12     
13     constructor(address _signer, address _owner) public payable{
14         owner = _owner;
15         signer = _signer;
16     }
17     
18     function lock(bytes32 r, bytes32 s) external {
19         require(sigCheck(PAUSED, r, s));
20         require(!paused);
21         
22         paused = true;
23     }
24     
25     function unlock(bytes32 r, bytes32 s) external {
26         require(sigCheck(UNPAUSED, r, s));
27         require(paused);
28         
29         paused = false;
30     }
31     
32     function withdraw() external {
33         require(!paused);
34         msg.sender.transfer(address(this).balance);
35     }
36     
37     function win(address _winner) external {
38         require(msg.sender == owner);
39         winners[_winner] = true;
40     }
41     
42     
43     function sigCheck(bytes32 _hash, bytes32 r, bytes32 s) internal view returns (bool) {
44       if(ecrecover(_hash, 27, r, s) == signer){
45         return(true);
46       }
47       else{
48         return(ecrecover(_hash, 28, r, s) == signer);
49       }
50 	}
51 }