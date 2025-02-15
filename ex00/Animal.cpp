#include "Animal.hpp"

Animal::Animal():_type("default")
{
    std::cout << "Default Animal instance created" << std::endl;
}

Animal::Animal(const Animal &copyAnimal)
{
    std::cout << "Animal instance copied" << std::endl;
    *this = copyAnimal;
}

Animal::~Animal()
{
    std::cout << "Animal instance destroyed" << std::endl;
}

Animal &Animal::operator=(const Animal &ani)
{
    std::cout << "Animal assignment operator invoked" << std::endl;
    if (this == &ani)
        return *this;

    this->_type = ani._type;
    return *this;
}

void Animal::makeSound(void)const
{
    std::cout << "This animal remains silent." << std::endl;
}

std::string	Animal::getType(void)const
{
    return (this->_type);
}