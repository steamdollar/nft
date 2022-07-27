// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "./ERC721.sol";

contract ERC721Enumerable is ERC721 {
    // 모든 토큰을 담고있는 배열
    uint[] private _allTokens;

    // 지갑 주소 > 그 지갑이 가진 토큰의 배열의 인덱스 > 토큰의 id까지 연결해주는 매핑
    // 얘를 들어 0x1234 가 토큰을 3개 가지고 있고, 그 중 1번 인덱스의 토큰아이디가 5라면
    // 0x1234 => {"1" => "5"}
    // _ownedTokens[address][index] = tokenId 처럼 나타낼 수 있다.
    mapping(address => mapping(uint => uint)) private _ownedTokens;

    //tokenId => index 를 연결해주는 매핑
    mapping(uint => uint) private _ownedTokenIndex;

    constructor(string memory _name, string memory _symbol) ERC721(_name, _symbol){}

    // 토큰의 총 갯수를 알려주는 함수
    function totalSupply() public view returns (uint) {
        return _allTokens.length;
    }
    
    function tokenByIndex(uint _index) public view returns (uint) {
        require(_index < _allTokens.length);
        return _allTokens[_index];
    }

    // _owner의 n번째 토큰 찾기
    function tokenOfOwnerByIndex (address _owner, uint _index) public view returns(uint) {
        require(_index < ERC721.balanceOf(_owner));
        return _ownedTokens[_owner][_index];
    }

    function mint(address _to) public {
        // 이 함수를 호출하면 이 안에서 ERC721 컨트랙트의 _mint함수를 실행하게끔 한다.
        _mint(_to, _allTokens.length);
    }

    function _afterToken(address _from, address _to, uint _tokenId) internal override {
        _allTokens.push(_allTokens.length);
        // 배열에 새로운 토큰을 추가
        
        uint length = ERC721.balanceOf(_to);
        // _to가 가진 토큰으 ㅣ수 + 1

        _ownedTokens[_to][length] = _tokenId;
        // 매핑에 새로운 토큰의 주인과 인덱스 추가
        _ownedTokenIndex[_tokenId] = length;
        // 토큰의 인덱스 추가
    }
}