// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";

contract DemoToken is ERC721, Ownable{
    uint256 COUNTER = 1;
    uint256 fee = 1 ether;

    constructor(string memory _name, string memory _symbol)
    ERC721(_name, _symbol)
     {}

     struct DemoT{
        string name;
        uint256 id;
        uint256 dna;
        uint8 level;
        uint8 rarity;
    
     }

    DemoT[] public demoT;

    event NewDemoT(address indexed owner, uint256 id, uint256 dna);

     // Helpers
    function _createRandomNum(uint256 _mod) internal view returns (uint256) {
        uint256 randomNum = uint256(
        keccak256(abi.encodePacked(block.timestamp, msg.sender))
        );
        return randomNum % _mod;
    }
    //Update fee
    function updateFee(uint256 _fee) external onlyOwner {
        fee = _fee;
    }

    //Create new Demo Token
    function _createDemoToken(string memory _name) internal {
        uint8 randRarity = uint8(_createRandomNum(100));
        uint256 randDna = _createRandomNum(10**16);
        DemoT memory newDemoT = DemoT(_name, COUNTER, randDna, 1, randRarity);
        demoT.push(newDemoT);
        _safeMint(msg.sender, COUNTER);
        emit NewDemoT(msg.sender, COUNTER, randDna);
        COUNTER++;
    }

    function createRandomLip(string memory _name) public payable {
       require(msg.value >= fee);
        _createDemoToken(_name);

    }

    //Getter
    function getDemoToken() public view returns (DemoT[] memory) {
       return demoT;
    }

    function getOwnerDemoToken(address _owner) public view returns (DemoT[] memory) {
        DemoT[] memory result = new DemoT[](balanceOf(_owner));
        uint256 counter = 0;
        for(uint256 i= 0; i < demoT.length; i++){
            if(ownerOf(i) == _owner){
                result[counter] = demoT[i];
                counter++;
            }
        }
        return result;
    }

    //level up function
    function levelUp(uint256 _demoTId) public {
        require(ownerOf(_demoTId) == msg.sender);
        DemoT storage demoToken = demoT[_demoTId];
        demoToken.level++;
    }
}

