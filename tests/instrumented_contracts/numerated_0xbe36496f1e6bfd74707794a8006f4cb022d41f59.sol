1 contract test {
2     
3     function a() public
4     {
5         msg.sender.transfer(this.balance);    
6     }
7     
8     
9 }