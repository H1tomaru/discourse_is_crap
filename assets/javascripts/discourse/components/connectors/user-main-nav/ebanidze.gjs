import dIcon from 'discourse/helpers/d-icon'

export default <template>
  <Link @route="user.kek" @model={{@outletArgs.model.username}}>
    {{dIcon "star-half-stroke"}} Отзывы
  </Link>
</template>
