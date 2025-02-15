#include "WrongCat.hpp"

WrongCat::WrongCat(): WrongAnimal()
{
    this->_type = "WrongCat";
    std::cout << "WrongCat instance initialized with default configuration" << std::endl;
}

WrongCat::WrongCat(const WrongCat &copyWrCat): WrongAnimal()
{
    std::cout << "WrongCat instance duplicated via copy constructor" << std::endl;
    *this = copyWrCat;
}

WrongCat::~WrongCat()
{
    std::cout << "WrongCat instance terminated" << std::endl;
}

WrongCat &WrongCat::operator=(const WrongCat &wrcat)
{
    std::cout << "WrongCat assignment operator executed" << std::endl;
    if (this == &wrcat)
        return *this;
    this->_type = wrcat._type;
    return *this;
}

void WrongCat::makeSound(void)const
{
    std::cout << this->getType() << "WrongCat meow" << std::endl;
}