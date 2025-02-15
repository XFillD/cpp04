#include "Dog.hpp"

Dog::Dog(): Animal()
{
    std::cout << "Default Dog object instantiated." << std::endl;
    this->_type = "Dog";
    this->_brain = new Brain();
    if (this->_brain == NULL)
    {
        perror("Allocation error for Dog Brain");
        std::cerr << "Process is terminating now." << std::endl;
        exit(1);
    }
}

Dog::Dog(const Dog &copyDog): Animal()
{
    std::cout << "Dog object created by copy constructor." << std::endl;
    *this = copyDog;
}

Dog::~Dog()
{
    delete(this->_brain);
    std::cout << "Dog object destroyed." << std::endl;
}

Dog &Dog::operator=(const Dog &dog)
{
    std::cout << "Dog copy assignment executed." << std::endl;
    if (this == &dog)
        return *this;
    this->_type = dog._type;
    this->_brain = new Brain();
    if (this->_brain == NULL)
    {
        perror("Allocation error for Dog Brain");
        std::cerr << "Process is terminating now." << std::endl;
        exit(1);
    }
    *this->_brain = *dog._brain;
    return *this;
}

void Dog::makeSound(void)const
{
    std::cout << this->getType() << "Woof" << std::endl;
}

void Dog::getIdeas(void)const
{
    for (int i = 0; i < 3; i++)
        std::cout << "\tDog's idea " << i << ": \"" << this->_brain->getIdea(i) << "\" located at " << this->_brain->getIdeaAddress(i) << std::endl;
}

void Dog::setIdea(size_t i, std::string idea)
{
    this->_brain->setIdea(i, idea);
}