import Link from '@ember/routing/link-component';
import dIcon from 'discourse/helpers/d-icon'

export default <template>
  <li>
    <Link @route="user.kek" class="btn">
      {{dIcon "star-half-stroke"}}
      Отзывы
    </Link>
  </li>
</template>
