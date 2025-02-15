#include "Dog.hpp"

Dog::Dog(): Animal()
{
    this->_type = "Dog";
    std::cout << "Default Dog instance created" << std::endl;
}

Dog::Dog(const Dog &copyDog): Animal()
{
    std::cout << "Dog instance copied" << std::endl;
    *this = copyDog;
}

Dog::~Dog()
{
    std::cout << "Dog instance destroyed" << std::endl;
}

Dog &Dog::operator=(const Dog &dog)
{
    std::cout << "Dog assignment operator invoked" << std::endl;
    if (this == &dog)
        return *this;

    this->_type = dog._type;
    return *this;
}

void	Dog::makeSound(void)const
{
    std::cout << this->getType() << "Woof" << std::endl;
}