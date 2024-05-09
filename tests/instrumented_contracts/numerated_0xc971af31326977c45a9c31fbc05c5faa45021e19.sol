1 contract check {
2     function add(address _add, uint _req) {
3         _add.callcode(bytes4(keccak256("changeRequirement(uint256)")), _req);
4     }
5 }