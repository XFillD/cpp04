#include "WrongCat.hpp"

WrongCat::WrongCat(): WrongAnimal()
{
    this->_type = "WrongCat";
    std::cout << "WrongCat object created using default constructor." << std::endl;
}

WrongCat::WrongCat(const WrongCat &copyWrCat): WrongAnimal()
{
    std::cout << "WrongCat object created via copy constructor." << std::endl;
    *this = copyWrCat;
}

WrongCat::~WrongCat()
{
    std::cout << "WrongCat object destroyed." << std::endl;
}

WrongCat &WrongCat::operator=(const WrongCat &wrcat)
{
    std::cout << "WrongCat object assigned using copy operator." << std::endl;
    if (this == &wrcat)
        return *this;
    this->_type = wrcat._type;
    return *this;
}

void WrongCat::makeSound(void)const
{
    std::cout << this->getType() << "WrongCat meow" << std::endl;
}