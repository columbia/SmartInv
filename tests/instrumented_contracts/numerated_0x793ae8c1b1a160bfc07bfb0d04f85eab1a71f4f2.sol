1 contract Faucet {
2     uint256 sendAmount;
3     mapping (address => uint) lastSent;
4     uint blockLimit;
5     function Faucet(){
6         
7 	sendAmount = 10000000000000000;
8         blockLimit = 5760;
9     }
10 	
11 	function getWei() returns (bool){
12 	    if(lastSent[msg.sender]<(block.number-blockLimit)&&address(this).balance>sendAmount){
13 	        msg.sender.send(sendAmount);
14 	        lastSent[msg.sender] = block.number;
15 	        return true;
16 	    } else {
17 	        return false;
18 	    }
19 	}
20 	
21 }